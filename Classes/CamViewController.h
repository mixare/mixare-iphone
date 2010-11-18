/* Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/> */

#import <UIKit/UIKit.h>
#import "Circle.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "Marker.h"
#import "MarkerObject.h"
#import "Circle.h"
#import "JsonHandler.h"
#import "Matrix.h"
#import "Camera.h"
#import "MixVector.h"
#import "PhysicalPlace.h"

@interface CamViewController : UIViewController <CLLocationManagerDelegate>{
    UIImagePickerController *_imgPicker;
	UIButton * _closeButton;
	UITabBarController * _tabController;
	UIWindow * _window;
	CMMotionManager *motionManager;
	CLLocationManager *_locManager;
	NSMutableArray * markers;
	NSOperationQueue *motionQueue;
	Circle * cView;
	MarkerObject* m;
	float currentHeading;
	//GLFloat rotMatrix[16];
	CMAttitude* referenceAttitude;
	//double changeX, changeY;
	Matrix * tempR, * finalR, *smoothR, *m1, *m2, *m3, *m4;
	NSMutableArray *histroy;
	NSUInteger _historyIndex;
	Camera* camera;
	Marker * messnerMarker;
	double changePitch, changeRoll,oldR, oldP;
	BOOL isFirstAcces;
}
@property (nonatomic,retain) UIImagePickerController *imgPicker;
@property (nonatomic,retain) UIButton * closeButton;
@property (nonatomic, retain) IBOutlet UITabBarController * tabController;
@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) CLLocationManager * locManager;
@property (nonatomic) NSUInteger historyIndex;
-(void) initCameraView;
-(void)initMarkersWithJSONData: (NSString*) jsonData;
-(void)showMarkers;
-(void)processMotion:(CMDeviceMotion *)motion withError:(NSError *)error;
-(float) getAngleFromCenter: (float) centerX centerY: (float) centerY postX: (float) postX postY: (float) postY;
-(void)calcPitchBearingFromRotationMatrix: (Matrix*) rotationM;
-(void) projectPointWithOrigin: (MixVector*) orgPoint projectPoint: (MixVector*) prjPoint addX: (float) addX addY: (float) addY;
@end
