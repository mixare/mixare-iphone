//
//  CamViewController.h
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

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
