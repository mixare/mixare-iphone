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
#import "Resources.h"

#define VIEWPORT_WIDTH_RADIANS 0.5
#define VIEWPORT_HEIGHT_RADIANS .7392

@implementation AugmentedViewController

@synthesize locationManager, accelerometerManager;
@synthesize centerCoordinate;
@synthesize scaleViewsBasedOnDistance, rotateViewsBasedOnPerspective;
@synthesize maximumScaleDistance;
@synthesize minimumScaleFactor, maximumRotationAngle;
@synthesize coordinates = ar_coordinates;
@synthesize locationDelegate, accelerometerDelegate;
@synthesize cameraController;
@synthesize maxRadiusLabel, valueLabel, slider, sliderButton, menuButton, backToPlugin, popUpView;

- (id)init {
	if (!(self = [super init])) return nil;
    [self loadSettings];
	return self;
}

- (void)loadSettings {
    ar_overlayView = nil;
	ar_coordinates = [[NSMutableArray alloc] init];
	ar_coordinateViews = [[NSMutableArray alloc] init];
	_updateTimer = nil;
	updateFrequency = 1 / 20.0;
    [self loadView];
    
#if !TARGET_IPHONE_SIMULATOR
    self.cameraController = [[CameraController alloc] init];
    [self.cameraController addVideoInput];
    [self.cameraController addVideoPreviewLayer];
    [self.cameraController setPortrait];
	[[self.view layer] addSublayer:[self.cameraController previewLayer]];
    [[self.cameraController captureSession] startRunning];
    popUpView = [[PopUpWebView alloc] initWithMainView:self.view padding:20 isTabbar:NO rightRotateable:NO alpha:.6];
#endif
	self.scaleViewsBasedOnDistance = NO;
	self.maximumScaleDistance = 0.0;
	self.minimumScaleFactor = 1.5;
	self.rotateViewsBasedOnPerspective = YES;
	self.maximumRotationAngle = M_PI / 6.0;
	self.wantsFullScreenLayout = NO;
	oldHeading = 0;
}

- (void)closeCameraView {
    [self viewWillDisappear:YES];
    [self.view removeFromSuperview];
    self.view = nil;
    [[self.cameraController captureSession] stopRunning];
    self.cameraController = nil;
    [self removeCoordinates];
}

- (id)initWithLocationManager:(CLLocationManager*)manager {
	if (!(self = [super init])) return nil;
	//use the passed in location manager instead of ours.
	[self startListening:manager];
    [self loadSettings];
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        ar_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    } else {
        ar_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    self.view.userInteractionEnabled = YES;
    ar_overlayView.userInteractionEnabled = YES;
}

- (void)setsUpdateFrequency:(double)newUpdateFrequency {
	updateFrequency = newUpdateFrequency;
	if (!_updateTimer) return;
	[_updateTimer invalidate];
	_updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateFrequency
													 target:self
												   selector:@selector(updateLocations:)
												   userInfo:nil
													repeats:YES];
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
		[self.locationManager stopUpdatingHeading];
        [self.locationManager stopUpdatingLocation];
	}
}

- (void)startListening:(CLLocationManager*)locManager {
	//start our heading readings and our accelerometer readings.
	if (!self.locationManager) {
		self.locationManager = locManager;
        //we want every move.
		self.locationManager.headingFilter = kCLHeadingFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		[self.locationManager startUpdatingHeading];
        [self.locationManager startUpdatingLocation];
	}
	//steal back the delegate.
	self.locationManager.delegate = self;
	if (!self.accelerometerManager) {
		self.accelerometerManager = [UIAccelerometer sharedAccelerometer];
		self.accelerometerManager.updateInterval = 0.01;
		self.accelerometerManager.delegate = self;
	}
	if (!self.centerCoordinate) {
		self.centerCoordinate = [[PoiItem alloc] initCoordinateWithRadialDistance:0 inclination:0 azimuth:0];
	}
}

- (CGPoint)pointInView:(UIView*)realityView forCoordinate:(PoiItem*)coordinate {
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
#define kFilteringFactorX 0.002
UIAccelerationValue rollingX, rollingZ;
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	// -1 face down.
	// 1 face up.
	//update the center coordinate.
	//NSLog(@"x: %f y: %f z: %f", acceleration.x, acceleration.y, acceleration.z);
	//this should be different based on orientation.
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        rollingZ  = (acceleration.z * kFilteringFactor) + (rollingZ  * (1.0 - kFilteringFactor));
        rollingX = (acceleration.x * kFilteringFactorX) + (rollingX * (1.0 - kFilteringFactorX));
    } else {
        rollingZ  = (acceleration.z * kFilteringFactor) + (rollingZ  * (1.0 - kFilteringFactor));
        rollingX = (acceleration.y * kFilteringFactorX) + (rollingX * (1.0 - kFilteringFactorX));
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
            double distance = [self.locationManager.location distanceFromLocation:item.geoLocation] / 1000;
            NSString *labelText = [NSString stringWithFormat:@"%@ \n %.2fkm", item.position.title, distance];
            viewToDraw.titleLabel.text = labelText;
			CGPoint loc = [self pointInView:ar_overlayView forCoordinate:item];
			CGFloat scaleFactor = 1.5;
			if (self.scaleViewsBasedOnDistance) {
				scaleFactor = 1.0 - self.minimumScaleFactor * (item.radialDistance / self.maximumScaleDistance);
			}
			float width = viewToDraw.bounds.size.width;
			float height = viewToDraw.bounds.size.height;
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
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        if (self.centerCoordinate.azimuth <(3*M_PI/2)) {
            self.centerCoordinate.azimuth += (M_PI/2);
        } else {
            self.centerCoordinate.azimuth = fmod(self.centerCoordinate.azimuth + (M_PI/2),360);
        }
    }
    int gradToRotate = newHeading.trueHeading - 90 - 22.5;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
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
	MarkerView *tempView = [[MarkerView alloc] initWithWebView:popUpView];
    tempView.frame = theFrame;
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
    if (coordinate.position.image == nil) {
        pointView.image = [UIImage imageWithContentsOfFile:[[[Resources getInstance] bundle] pathForResource:@"circle" ofType:@"png"]];
    } else {
        pointView.image = coordinate.position.image;
    }
	pointView.frame = CGRectMake((BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), 0, pointView.image.size.width, pointView.image.size.height);
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BOX_HEIGHT / 2.0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    double distance = [self.locationManager.location distanceFromLocation:coordinate.geoLocation] / 1000;
    NSString *labelText = [NSString stringWithFormat:@"%@ \n %.2fkm", coordinate.position.title, distance];
	titleLabel.text = labelText;
    //Markers get automatically resized
    [titleLabel sizeToFit];
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, pointView.image.size.height + 5, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
    tempView.url = coordinate.position.url;
    [tempView setTitleLabel:titleLabel];
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
    tempView.userInteractionEnabled = YES;
	return tempView;
}

- (void)viewDidAppear:(BOOL)animated {
#if !TARGET_IPHONE_SIMULATOR
    [ar_overlayView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
#endif
	if (!_updateTimer) {
		_updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateFrequency
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
    radarView = [[Radar alloc] initWithFrame:CGRectMake(2, 2, 61, 61)];
    radarViewPort = [[RadarViewPortView alloc] initWithFrame:CGRectMake(2, 2, 61, 61)];
    
    maxRadiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 25, 30, 12)];
    maxRadiusLabel.backgroundColor = [UIColor blackColor];
    maxRadiusLabel.textColor = [UIColor whiteColor];
    maxRadiusLabel.font = [UIFont systemFontOfSize:10.0];
    maxRadiusLabel.textAlignment = NSTextAlignmentCenter;
    maxRadiusLabel.text = @"80 km";
    maxRadiusLabel.hidden = YES;
    
    UILabel *northLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 2, 10, 10)];
    northLabel.backgroundColor = [UIColor blackColor];
    northLabel.textColor = [UIColor whiteColor];
    northLabel.font = [UIFont systemFontOfSize:8.0];
    northLabel.textAlignment = NSTextAlignmentCenter;
    northLabel.text = @"N";
    northLabel.alpha = 0.8;
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.5, 64, 45, 12)];
    valueLabel.backgroundColor = [UIColor blackColor];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont systemFontOfSize:10.0];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.hidden = NO;
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(62, 5, 128, 23)];
    slider.alpha = 0.7;
    slider.hidden = YES;
    slider.minimumValue = 1.0;
    slider.maximumValue = 80.0;
    slider.continuous= NO;
    
    sliderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sliderButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 0, 65, 30);
    [sliderButton setTitle:NSLocalizedString(@"Radius",nil) forState:UIControlStateNormal];
    sliderButton.alpha = 0.7;
    
    menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 0, 65, 30);
    [menuButton setTitle:NSLocalizedString(@"Menu",nil) forState:UIControlStateNormal];
    menuButton.alpha = 0.7;
    
    backToPlugin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backToPlugin.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 35, 130, 30);
    [backToPlugin setTitle:NSLocalizedString(@"Main menu",nil) forState:UIControlStateNormal];
    [backToPlugin setTintColor:[UIColor grayColor]];
    [backToPlugin setAlpha:0.7];
    
    float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"] floatValue];
    if (radius <= 0 || radius > 100) {
        slider.value = 5.0;
        valueLabel.text = @"5.0 km";
    } else {
        slider.value = radius;
        NSLog(@"RADIUS VALUE: %f", radius);
        valueLabel.text = [NSString stringWithFormat:@"%.2f km", radius];
    }
    
    [ar_overlayView addSubview:radarView];
    [ar_overlayView addSubview:radarViewPort];
    [ar_overlayView addSubview:northLabel];
    [ar_overlayView addSubview:maxRadiusLabel];
    [ar_overlayView addSubview:valueLabel];
    [ar_overlayView addSubview:slider];
    [ar_overlayView addSubview:sliderButton];
    [ar_overlayView addSubview:menuButton];
    [ar_overlayView addSubview:backToPlugin];
    
    [self.view addSubview:ar_overlayView];
}

/***
 *
 *  Transform view to portrait
 *  @param viewObject
 *
 ***/
- (void)setViewToPortrait {
    [cameraController setPortrait];
    ar_overlayView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    backToPlugin.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 35, 130, 30);
    menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 0, 65, 30);
    sliderButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 0, 65, 30);
    slider.frame = CGRectMake(62, 5, 128, 23);
    maxRadiusLabel.frame = CGRectMake(158, 25, 30, 12);
}

/***
 *
 *  Transform view to landscape
 *  @param viewObject
 *
 ***/
- (void)setViewToLandscape {
    [cameraController setLandscapeLeft];
    ar_overlayView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    menuButton.bounds = CGRectMake([UIScreen mainScreen].bounds.size.height - 130, 0, 65, 30);
    menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 130, 0, 65, 30);
    sliderButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 65, 0, 65, 30);
    slider.frame = CGRectMake(62, 5, 288, 23);
    maxRadiusLabel.frame = CGRectMake(318, 28, 30, 10);
    backToPlugin.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 130, 35, 130, 30);
}

- (BOOL)shouldAutorotate {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        return NO;
    }
    return YES;
}

@end
