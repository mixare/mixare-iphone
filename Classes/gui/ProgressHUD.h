//
//  ProgressHUD.h
//  Mixare
//
//  Created by Aswin Ly on 22-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixareAppDelegate.h"

@interface ProgressHUD : UIAlertView {
    UIActivityIndicatorView *activityIndicator;
    UILabel *progressMessage;
    UIImageView *backgroundImageView;
    
    MixareAppDelegate *__weak appDelegate;
}

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *progressMessage;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic, weak) MixareAppDelegate *appDelegate;

- (id)initWithLabel:(NSString *)text;
- (void)show;
- (void)dismiss;

@end
