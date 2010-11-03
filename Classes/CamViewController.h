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
#import "Marker.h"

@interface CamViewController : UIViewController {
    UIImagePickerController *_imgPicker;
	UIButton * _closeButton;
	UITabBarController * _tabController;
	UIWindow * _window;
	CMMotionManager *motionManager;
	NSMutableArray * markers;
	CMAttitude *referenceAttitude;
	//GLFloat rotMatrix[16];
}
@property (nonatomic,retain) UIImagePickerController *imgPicker;
@property (nonatomic,retain) UIButton * closeButton;
@property (nonatomic, retain) IBOutlet UITabBarController * tabController;
@property (nonatomic, retain) IBOutlet UIWindow * window;

-(void) initCameraView;
-(void)initMarkersWithJSONData: (NSString*) jsonData;
-(void)showMarkers;
@end
