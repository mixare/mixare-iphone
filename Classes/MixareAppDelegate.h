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
#import "CamViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "Circle.h"
#import "MarkerObject.h" 

#import "Marker.h"

@interface MixareAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIWindow *window;
    //UITabBarController *tabBarController;
	UIImagePickerController* imgPicker;
	UIButton *closeButton;
	CamViewController * _cameraController;
	CLLocationManager * _locManager;
	UIView * _view;
	Circle *cView;
	float currentHeading;
	UIAccelerometer * acceloometer;
	MarkerObject * m;
	UITabBarController *_tabBarController;
	CMAttitude *referenceAttitude;
	NSOperationQueue *motionQueue;
	CMMotionManager *motionManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) CLLocationManager * locManager;
@property (nonatomic, retain) CamViewController * camController;
@property (nonatomic, retain) IBOutlet UIView * view;

-(void)initCameraView;
-(void)initLocationManager;
@end
