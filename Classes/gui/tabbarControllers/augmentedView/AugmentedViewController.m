/*
 * Copyright (C) 2010- Peer internet solutions
 *
 * This file is part of mixare.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>
 */

#import "AugmentedViewController.h"
#import <QuartzCore/QuartzCore.h>

#define VIEWPORT_WIDTH_RADIANS 0.5
#define VIEWPORT_HEIGHT_RADIANS .7392

@implementation AugmentedViewController

@synthesize locationManager, accelerometerManager;
@synthesize centerCoordinate;
@synthesize scaleViewsBasedOnDistance, rotateViewsBasedOnPerspective;
@synthesize maximumScaleDistance;
@synthesize minimumScaleFactor, maximumRotationAngle;
@synthesize updateFrequency;
@synthesize coordinates = ar_coordinates;
@synthesize locationDelegate, accelerometerDelegate;
@synthesize cameraController;

- (id)init {
	if (!(self = [super init])) return nil;
	ar_overlayView = nil;
	ar_coordinates = [[NSMutableArray alloc] init];
	ar_coordinateViews = [[NSMutableArray alloc] init];
	_updateTimer = nil;
	self.updateFrequency = 1 / 20.0;
	
#if !TARGET_IPHONE_SIMULATOR
	self.cameraController = [[UIImagePickerController alloc] init];
	self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
	CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.232, 1.232);
	self.cameraController.cameraViewTransform = cameraTransform;
    //CGAffineTransformScale(self.cameraController.cameraViewTransform, 1.23f,  1.23f);
	self.cameraController.showsCameraControls = NO;
	self.cameraController.navigationBarHidden = YES;
#endif
	self.scaleViewsBasedOnDistance = NO;
	self.maximumScaleDistance = 0.0;
	self.minimumScaleFactor = 1.5;
	self.rotateViewsBasedOnPerspective = YES;
	self.maximumRotationAngle = M_PI / 6.0;
	self.wantsFullScreenLayout = NO;
	oldHeading = 0;
	return self;
}

- (void)closeCameraView {
    [self.cameraController viewWillDisappear:YES];
	[self.cameraController.view removeFromSuperview];
    [self viewWillDisappear:YES];
    [self.view removeFromSuperview];
    self.view = nil;
    self.cameraController = nil;
    [self removeCoordinates];
}

- (id)initWithLocationManager:(CLLocationManager*)manager {
	if (!(self = [super init])) return nil;
	//use the passed in location manager instead of ours.
	self.locationManager = manager;
	self.locationManager.delegate = self;
	self.locationDelegate = nil;
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    ar_overlayView = [[UIView alloc] initWithFrame:CGRectZero];
	//ar_overlayView = [[MarkerView alloc] initWithFrame:CGRectZero];
	radarView = [[Radar alloc] initWithFrame:CGRectMake(2, 2, 61, 61)];	
    radarViewPort = [[RadarViewPortView alloc] initWithFrame:CGRectMake(2, 2, 61, 61)];
	self.view = ar_overlayView;
    [self.view addSubview:radarView];
    [self.view addSubview:radarViewPort];
}

- (void)setsUpdateFrequency:(double)newUpdateFrequency {
	updateFrequency = newUpdateFrequency;
	if (!_updateTimer) return;
	[_updateTimer invalidate];
	_updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateFrequency
													 target:self
												   selector:@selector(updateLocations:)
												   userInfo:nil
													repeats:YES];
}

- (void)openUrlView:(NSString*)url {
    if (closeButton != nil) {
        [closeButton removeFromSuperview];
        closeButton = nil;
    }
    if (popUpView != nil) {
        [popUpView removeFromSuperview];
        popUpView = nil;
    }
    popUpView = [[PopUpWebView alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 40)];
    NSURL *requestURL = [NSURL URLWithString:url];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
	[popUpView loadRequest:requestObj];
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.text = @"Close";
    closeButton.alpha = 1;
    closeButton.titleLabel.textColor = [UIColor blackColor];
    closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height - 35, 100, 35);
    [self.cameraController.view addSubview:popUpView];
    [self.cameraController.view addSubview:closeButton];
}

- (void)buttonClick:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    closeButton.alpha = 0;
    popUpView.alpha = 0;
    [UIView commitAnimations];
    [popUpView removeFromSuperview];
    [closeButton removeFromSuperview];
    popUpView = nil;
    closeButton = nil;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch * touch = [touches anyObject];
    CGPoint pos = [touch locationInView: [UIApplication sharedApplication].keyWindow];
    pos.x = pos.x - 100;
    pos.y = pos.y - 50;
    NSLog(@"Position of touch: %.3f, %.3f", pos.x, pos.y);
    MarkerView *marker = [self getClosestMarker:pos];
    if (marker != nil) {
        //[marker pressedButton];
        [self openUrlView:marker.url];
    }
}

- (MarkerView*)getClosestMarker:(CGPoint)position {
    MarkerView *closestMarker = nil;
    int index = 0;
    for (PoiItem *item in ar_coordinates) {
		MarkerView *viewToDraw = ar_coordinateViews[index];
        if ([self isCloser:position newMarker:viewToDraw compareMarker:closestMarker]) {
            closestMarker = viewToDraw;
        }
        index++;
    }
    if ([self isCloseEnough:position marker:closestMarker] && closestMarker != nil) {
        NSLog(@"Position of closest marker: %.3f, %.3f:", closestMarker.frame.origin.x, closestMarker.frame.origin.y);
        NSLog(@"Closest URL: %@", closestMarker.url);
        return closestMarker;
    }
    return nil;
}

- (BOOL)isCloser:(CGPoint)position newMarker:(MarkerView*)marker1 compareMarker:(MarkerView*)marker2 {
    if (marker2 == nil) {
        return YES;
    }
    int newMarkerDifference = (fmax(marker1.frame.origin.x, position.x) - fmin(marker1.frame.origin.x, position.x)) + (fmax(marker1.frame.origin.y, position.y) - fmin(marker1.frame.origin.y, position.y));
    int compareMarkerDifference = (fmax(marker2.frame.origin.x, position.x) - fmin(marker2.frame.origin.x, position.x)) + (fmax(marker2.frame.origin.y, position.y) - fmin(marker2.frame.origin.y, position.y));
    if (newMarkerDifference < compareMarkerDifference) {
        return YES;
    }
    return NO;
}

- (BOOL)isCloseEnough:(CGPoint)position marker:(MarkerView*)marker {
    if ((fmax(marker.frame.origin.x, position.x) - (fmin(marker.frame.origin.x, position.x))) > ([UIScreen mainScreen].bounds.size.width / 2)) {
        return NO;
    } else if ((fmax(marker.frame.origin.y, position.y) - (fmin(marker.frame.origin.y, position.y))) > ([UIScreen mainScreen].bounds.size.height / 2)) {
        return NO;
    }
    return YES;
}

- (BOOL)viewportContainsCoordinate:(PoiItem*)coordinate {
	double centerAzimuth = self.centerCoordinate.azimuth;
	double leftAzimuth = centerAzimuth - VIEWPORT_WIDTH_RADIANS / 2.0;
	if (leftAzimuth < 0.0) {
		leftAzimuth = 2 * M_PI + leftAzimuth;
	}
	double rightAzimuth = centerAzimuth + VIEWPORT_WIDTH_RADIANS / 2.0;
	if (rightAzimuth > 2 * M_PI) {
		rightAzimuth = rightAzimuth - 2 * M_PI;
	}
	BOOL result = (coordinate.azimuth > leftAzimuth && coordinate.azimuth < rightAzimuth);
	if (leftAzimuth > rightAzimuth) {
		result = (coordinate.azimuth < rightAzimuth || coordinate.azimuth > leftAzimuth);
	}
	double centerInclination = self.centerCoordinate.inclination;
	double bottomInclination = centerInclination - VIEWPORT_HEIGHT_RADIANS / 2.0;
	double topInclination = centerInclination + VIEWPORT_HEIGHT_RADIANS / 2.0;
	//check the height.
	result = result && (coordinate.inclination > bottomInclination && coordinate.inclination < topInclination);
	//NSLog(@"coordinate: %@ result: %@", coordinate, result?@"YES":@"NO");
	return result;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)stopListening {
	if (self.locationManager != nil) {
		[locationManager stopUpdatingHeading];
	}
}

- (void)markerClick:(id)sender {
    NSLog(@"MARKER");
}

- (void)startListening:(CLLocationManager*)locManager {
	//start our heading readings and our accelerometer readings.
	if (!self.locationManager) {
		self.locationManager = locManager;
        //we want every move.
		self.locationManager.headingFilter = kCLHeadingFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		[self.locationManager startUpdatingHeading];
	}
	//steal back the delegate.
	self.locationManager.delegate = self;
	if (!self.accelerometerManager) {
		self.accelerometerManager = [UIAccelerometer sharedAccelerometer];
		self.accelerometerManager.updateInterval = 0.01;
		self.accelerometerManager.delegate = self;
	}
	if (!self.centerCoordinate) {
		self.centerCoordinate = [[PoiItem alloc] coordinateWithRadialDistance:0 inclination:0 azimuth:0];
	}
}

- (CGPoint)pointInView:(MarkerView*)realityView forCoordinate:(PoiItem*)coordinate {
	CGPoint point;
	//x coordinate.
	double pointAzimuth = coordinate.azimuth;
	//our x numbers are left based.
	double leftAzimuth = self.centerCoordinate.azimuth - VIEWPORT_WIDTH_RADIANS / 2.0;
	if (leftAzimuth < 0.0) {
		leftAzimuth = 2 * M_PI + leftAzimuth;
	}
	if (pointAzimuth < leftAzimuth) {
		//it's past the 0 point.
		point.x = ((2 * M_PI - leftAzimuth + pointAzimuth) / VIEWPORT_WIDTH_RADIANS) * realityView.frame.size.width;
	} else {
		point.x = ((pointAzimuth - leftAzimuth) / VIEWPORT_WIDTH_RADIANS) * realityView.frame.size.width;
	}
	//y coordinate.
	double pointInclination = coordinate.inclination;
	double topInclination = self.centerCoordinate.inclination - VIEWPORT_HEIGHT_RADIANS / 2.0;
	point.y = realityView.frame.size.height - ((pointInclination - topInclination) / VIEWPORT_HEIGHT_RADIANS) * realityView.frame.size.height;
	return point;
}

- (CGPoint)rotatePointAboutOrigin:(CGPoint)point angle:(float)angle {
    float s = sinf(angle);
    float c = cosf(angle);
    return CGPointMake(c * point.x - s * point.y, s * point.x + c * point.y);
}

#define kFilteringFactor 0.05
UIAccelerationValue rollingX, rollingZ;
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	// -1 face down.
	// 1 face up.
	//update the center coordinate.
	//NSLog(@"x: %f y: %f z: %f", acceleration.x, acceleration.y, acceleration.z);
	//this should be different based on orientation.
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        rollingZ  = (acceleration.z * kFilteringFactor) + (rollingZ  * (1.0 - kFilteringFactor));
        rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
    } else {
        rollingZ  = (acceleration.z * kFilteringFactor) + (rollingZ  * (1.0 - kFilteringFactor));
        rollingX = (acceleration.y * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
	}
	if (rollingZ > 0.0) {
		self.centerCoordinate.inclination = atan(rollingX / rollingZ) + M_PI / 2.0;
	} else if (rollingZ < 0.0) {
		self.centerCoordinate.inclination = atan(rollingX / rollingZ) - M_PI / 2.0;// + M_PI;
	} else if (rollingX < 0) {
		self.centerCoordinate.inclination = M_PI/2.0;
	} else if (rollingX >= 0) {
		self.centerCoordinate.inclination = 3 * M_PI/2.0;
	}
	if (self.accelerometerDelegate && [self.accelerometerDelegate respondsToSelector:@selector(accelerometer:didAccelerate:)]) {
		//forward the acceleromter.
		[self.accelerometerDelegate accelerometer:accelerometer didAccelerate:acceleration];
	}
}

NSComparisonResult LocationSortClosestFirst(PoiItem *s1, PoiItem *s2, void *ignore) {
    if (s1.radialDistance < s2.radialDistance) {
		return NSOrderedAscending;
	} else if (s1.radialDistance > s2.radialDistance) {
		return NSOrderedDescending;
	} else {
		return NSOrderedSame;
	}
}

- (void)refresh:(NSMutableArray*)dataSources {
    [self removeCoordinates];
    for (DataSource *data in dataSources) {
        [self addPoiItemsFromDataSource:data];
    }
}

- (void)addPoiItemsFromDataSource:(DataSource *)data {
	if (data.positions != nil) {
		for (Position *pos in data.positions) {
            [self addCoordinate:pos.poiItem animated:NO];
		}
	}
}

- (void)addCoordinate:(PoiItem*)coordinate {
	[self addCoordinate:coordinate animated:YES];
}

- (void)addCoordinate:(PoiItem*)coordinate animated:(BOOL)animated {
	//do some kind of animation?
	[ar_coordinates addObject:coordinate];
	if (coordinate.radialDistance > self.maximumScaleDistance) {
		self.maximumScaleDistance = coordinate.radialDistance;
	}
	//message the delegate.
	[ar_coordinateViews addObject:[self viewForCoordinate:coordinate]];
}

- (void)addCoordinates:(NSArray*)newCoordinates {
	//go through and add each coordinate.
	for (PoiItem *coordinate in newCoordinates) {
		[self addCoordinate:coordinate animated:NO];
	}
}

- (void)removeCoordinate:(PoiItem*)coordinate {
	[self removeCoordinate:coordinate animated:YES];
}

- (void)removeCoordinate:(PoiItem*)coordinate animated:(BOOL)animated {
	//do some kind of animation?
	[ar_coordinates removeObject:coordinate];
}

- (void)removeCoordinates {	
	[ar_coordinates removeAllObjects];
	[ar_coordinateViews removeAllObjects];
    for (UIView *view in ar_overlayView.subviews) {
        [view removeFromSuperview];
    };
}

- (void)updateLocations:(NSTimer*)timer {
	//update locations!
	if (!ar_coordinateViews || ar_coordinateViews.count == 0) {
		return;
	}
	int index = 0;
    NSMutableArray *radarPointValues = [[NSMutableArray alloc] initWithCapacity:[ar_coordinates count]];
	for (PoiItem *item in ar_coordinates) {
		MarkerView *viewToDraw = ar_coordinateViews[index];
		if ([self viewportContainsCoordinate:item]) {
			CGPoint loc = [self pointInView:ar_overlayView forCoordinate:item];
			CGFloat scaleFactor = 1.5;
			if (self.scaleViewsBasedOnDistance) {
				scaleFactor = 1.0 - self.minimumScaleFactor * (item.radialDistance / self.maximumScaleDistance);
			}
			float width = viewToDraw.bounds.size.width * scaleFactor;
			float height = viewToDraw.bounds.size.height * scaleFactor;
			viewToDraw.frame = CGRectMake(loc.x - width / 2.0, loc.y-height / 2.0, width, height);
			CATransform3D transform = CATransform3DIdentity;
			//set the scale if it needs it.
			if (self.scaleViewsBasedOnDistance) {
				//scale the perspective transform if we have one.
				transform = CATransform3DScale(transform, scaleFactor, scaleFactor, scaleFactor);
			}
			if (self.rotateViewsBasedOnPerspective) {
				transform.m34 = 1.0 / 300.0;
				double itemAzimuth = item.azimuth;
				double centerAzimuth = self.centerCoordinate.azimuth;
				if (itemAzimuth - centerAzimuth > M_PI) centerAzimuth += 2 * M_PI;
				if (itemAzimuth - centerAzimuth < -M_PI) itemAzimuth += 2 * M_PI;
				
				double angleDifference = itemAzimuth - centerAzimuth;
				transform = CATransform3DRotate(transform, self.maximumRotationAngle * angleDifference / (VIEWPORT_HEIGHT_RADIANS / 2.0) , 0, 1, 0);
			}
			viewToDraw.layer.transform = transform;
			//if we don't have a superview, set it up.
			if (!(viewToDraw.superview)) {
				[ar_overlayView addSubview:viewToDraw];
				[ar_overlayView sendSubviewToBack:viewToDraw];
			}
		} else {
			[viewToDraw removeFromSuperview];
			viewToDraw.transform = CGAffineTransformIdentity;
		}
        [radarPointValues addObject:item];
		index++;
	}
    float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"] floatValue];
    if (radius <= 0 || radius > 100) {
        radius = 5.0;
    }
    radarView.pois = radarPointValues;
    radarView.radius = radius;
    [radarView setNeedsDisplay];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading {
	self.centerCoordinate.azimuth = fmod(newHeading.magneticHeading, 360.0) * (2 * (M_PI / 360.0));
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        if (self.centerCoordinate.azimuth <(3*M_PI/2)) {
            self.centerCoordinate.azimuth += (M_PI/2);
        } else {
            self.centerCoordinate.azimuth = fmod(self.centerCoordinate.azimuth + (M_PI/2),360);
        }
    }
    int gradToRotate = newHeading.trueHeading - 90 - 22.5;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        gradToRotate += 90;
    }
    if (gradToRotate < 0) {
        gradToRotate = 360 + gradToRotate;
    }
	radarViewPort.referenceAngle = gradToRotate;
    [radarViewPort setNeedsDisplay];
    oldHeading = newHeading.trueHeading;
	if (self.locationDelegate && [self.locationDelegate respondsToSelector:@selector(locationManager:didUpdateHeading:)]) {
		//forward the call.
		[self.locationDelegate locationManager:manager didUpdateHeading:newHeading];
	}
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager*)manager {
	if (self.locationDelegate && [self.locationDelegate respondsToSelector:@selector(locationManagerShouldDisplayHeadingCalibration:)]) {
		//forward the call.
		return [self.locationDelegate locationManagerShouldDisplayHeadingCalibration:manager];
	}
	return YES;
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
	if (self.locationDelegate && [self.locationDelegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
		//forward the call.
		[self.locationDelegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
	}
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
	if (self.locationDelegate && [self.locationDelegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
		//forward the call.
		return [self.locationDelegate locationManager:manager didFailWithError:error];
	}
}

/***
 *
 *  Marker image view at located positions of active sources
 *  @param coordinate
 *
 ***/

#define BOX_WIDTH 250
#define BOX_HEIGHT 200
- (MarkerView*)viewForCoordinate:(PoiItem*)coordinate {
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	MarkerView *tempView = [[MarkerView alloc] initWithFrame:theFrame];
    tempView.userInteractionEnabled = NO;
    tempView.webActivated = NO;
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
    if (coordinate.position.image == nil) {
        pointView.image = [UIImage imageNamed:@"circle.png"];
    } else {
        pointView.image = coordinate.position.image;
    }
	pointView.frame = CGRectMake((BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), 0, pointView.image.size.width, pointView.image.size.height);
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BOX_HEIGHT / 2.0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = coordinate.title;
    //Markers get automatically resized
    [titleLabel sizeToFit];
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, pointView.image.size.height + 5, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
    tempView.url = coordinate.url;
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
    tempView.userInteractionEnabled = YES;
	return tempView;
}

- (void)viewDidAppear:(BOOL)animated {
#if !TARGET_IPHONE_SIMULATOR
	[self.cameraController setCameraOverlayView:ar_overlayView];
	[self presentViewController:self.cameraController animated:NO completion:nil];
	//[ar_overlayView setFrame:self.cameraController.view.bounds];
    [ar_overlayView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
#endif
	if (!_updateTimer) {
		_updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateFrequency
                                                         target:self
                                                       selector:@selector(updateLocations:)
                                                       userInfo:nil
                                                        repeats:YES];
	}
	[super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	ar_overlayView = nil;
}

- (void)initInterface {
    UILabel *northLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 2, 10, 10)];
    northLabel.backgroundColor = [UIColor blackColor];
    northLabel.textColor = [UIColor whiteColor];
    northLabel.font = [UIFont systemFontOfSize:8.0];
    northLabel.textAlignment = NSTextAlignmentCenter;
    northLabel.text = @"N";
    northLabel.alpha = 0.8;
    
    [self.view addSubview:northLabel];
}


@end
