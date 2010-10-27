//
//  CamViewController.h
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CamViewController : UIViewController {
    UIImagePickerController *_imgPicker;
	UIButton * _closeButton;
	UITabBarController * _tabController;
	UIWindow * _window;
}
@property (nonatomic,retain) UIImagePickerController *imgPicker;
@property (nonatomic,retain) UIButton * closeButton;
@property (nonatomic, retain) IBOutlet UITabBarController * tabController;
@property (nonatomic, retain) IBOutlet UIWindow * window;
-(void) initCameraView;
@end
