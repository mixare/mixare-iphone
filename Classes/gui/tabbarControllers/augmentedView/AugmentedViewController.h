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
#import <UIKit/UIKit.h>
#import "MarkerView.h"
#import <CoreLocation/CoreLocation.h>
#import "DataSource.h"
#import "Radar.h"
#import "PoiItem.h"
#import "RadarViewPortView.h"
#import "PopUpWebView.h"
#import "CameraController.h"

@interface AugmentedViewController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	UIAccelerometer *accelerometerManager;
	PoiItem *centerCoordinate;
    CameraController *cameraController;
	NSObject<CLLocationManagerDelegate> *__weak locationDelegate;
	NSObject<UIAccelerometerDelegate> *__weak accelerometerDelegate;
	BOOL scaleViewsBasedOnDistance;
	double maximumScaleDistance;
	double minimumScaleFactor;
	//defaults to 20hz;
	double updateFrequency;
	BOOL rotateViewsBasedOnPerspective;
	double maximumRotationAngle;
    
    UIButton *backToPlugin;
    UIButton *menuButton;
    UISlider *slider;
    UIButton *sliderButton;
    UILabel *maxRadiusLabel;
    UILabel *valueLabel;
    UIButton *closeButton;
	
@private
	int oldHeading;
	NSTimer *_updateTimer;
	UIView *ar_overlayView;
	Radar *radarView;
    RadarViewPortView *radarViewPort;
	NSMutableArray *ar_coordinates;
	NSMutableArray *ar_coordinateViews;
}

@property PopUpWebView *popUpView;
@property UILabel *maxRadiusLabel;
@property UILabel *valueLabel;
@property UISlider *slider;
@property UIButton *sliderButton;
@property UIButton *menuButton;
@property UIButton *backToPlugin;

@property (readonly) NSArray *coordinates;
@property BOOL scaleViewsBasedOnDistance;
@property double maximumScaleDistance;
@property double minimumScaleFactor;
@property BOOL rotateViewsBasedOnPerspective;
@property double maximumRotationAngle;

@property (nonatomic, strong) CameraController *cameraController;
@property (nonatomic, weak) NSObject<CLLocationManagerDelegate> *locationDelegate;
@property (nonatomic, weak) NSObject<UIAccelerometerDelegate> *accelerometerDelegate;
@property (strong) PoiItem *centerCoordinate;
@property (nonatomic, strong) UIAccelerometer *accelerometerManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (id)initWithLocationManager:(CLLocationManager*)manager;
- (void)refresh:(NSMutableArray*)dataSources;
- (void)closeCameraView;
- (void)startListening:(CLLocationManager*)locManager;
- (void)stopListening;
- (void)initInterface;

- (void)setViewToPortrait;
- (void)setViewToLandscape;



@end
