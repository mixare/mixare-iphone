//
//  FirstViewController.h
//  Mixare
//
//  Created by jakob on 05.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraViewController : UIViewController {
    UIImagePickerController *imgPicker;
    UIView * cameraView;
}
@property (nonatomic,retain) UIImagePickerController *imgPicker;
@property (nonatomic,retain) IBOutlet UIView * cameraView;
@end
