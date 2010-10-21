//
//  MixareAppDelegate.h
//  Mixare
//
//  Created by jakob on 05.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface MixareAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIImagePickerController* imgPicker;
	UIButton *closeButton;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
-(void)initCameraView;
@end
