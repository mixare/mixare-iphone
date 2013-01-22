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
//
//  PopUpWebView.m
//  Mixare
//
//  Created by Aswin Ly on 11-12-12.
//

#import "PopUpWebView.h"
#import "ProgressHUD.h"
#import "Resources.h"

@implementation PopUpWebView

static ProgressHUD *hud;

- (id)initWithMainView:(UIView*)view padding:(int)pad isTabbar:(BOOL)tab rightRotateable:(BOOL)rotate alpha:(float)alp {
    self = [super init];
    if (self) {
        hud = [[ProgressHUD alloc] initWithLabel:NSLocalizedStringFromTableInBundle(@"Loading...", @"Localizable", [[Resources getInstance] bundle], @"")];
        alpha = alp;
        mainView = view;
        rotateable = rotate;
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        if ([UIApplication sharedApplication].isStatusBarHidden) {
            statusBarHeight = 0;
        }
        int tabBar = 0;
        if (tab) {
            tabBar = 49;
        } 
        windowPortrait = CGRectMake(pad, pad,
                                    [UIScreen mainScreen].bounds.size.width - (pad * 2),
                                    [UIScreen mainScreen].bounds.size.height - tabBar - statusBarHeight - (pad * 2));
        buttonPortrait = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50,
                                    [UIScreen mainScreen].bounds.size.height - tabBar - statusBarHeight - 35,
                                    100, 35);
        
        windowLandscape = CGRectMake(pad, pad,
                                    [UIScreen mainScreen].bounds.size.height - (pad * 2),
                                    [UIScreen mainScreen].bounds.size.width - tabBar - statusBarHeight - (pad * 2));
        buttonLandscape = CGRectMake([UIScreen mainScreen].bounds.size.height / 2 - 50,
                                    [UIScreen mainScreen].bounds.size.width - tabBar - statusBarHeight - 35,
                                    100, 35);
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didRotate:)
                                                     name:@"UIDeviceOrientationDidChangeNotification"
                                                   object:nil];
    }
    return self;
}

- (void)openUrlView:(NSString*)url {
    if (closeButton != nil) {
        [closeButton removeFromSuperview];
        closeButton = nil;
    }
    if (popUpView != nil) {
        [popUpView removeFromSuperview];
        popUpView = nil;
    }
    CGRect windowDimension = windowPortrait;
    CGRect buttonDimension = buttonPortrait;
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
        windowDimension = windowLandscape;
        buttonDimension = buttonLandscape;
    }
    popUpView = [[UIWebView alloc] initWithFrame:windowDimension];
    [popUpView setBackgroundColor:[UIColor blackColor]];
    popUpView.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [popUpView setAlpha:alpha];
    [UIView commitAnimations];
    
    [hud show];
    [self performSelectorInBackground:@selector(loadUrl:) withObject:url];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.text = NSLocalizedString(@"Close", nil);
    closeButton.alpha = 1;
    closeButton.titleLabel.textColor = [UIColor blackColor];
    closeButton.frame = buttonDimension;
    [mainView addSubview:popUpView];
    [mainView addSubview:closeButton];
}

- (void)loadUrl:(NSString*)url {
    NSURL *requestURL = [NSURL URLWithString:url];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
	[popUpView loadRequest:requestObj];
    [hud dismiss];
}

- (void)buttonClick:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    closeButton.alpha = 0;
    popUpView.alpha = 0;
    [UIView commitAnimations];
}

/***
 *
 *  Device rotation check
 *  @param notification
 *
 ***/
- (void)didRotate:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        [self setLandscape];
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight && rotateable) {
        [self setLandscape];
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait && beforeWasLandscape) {
        [self setPortrait];
    }
}

- (void)setLandscape {
    popUpView.frame = windowLandscape;
    closeButton.frame = buttonLandscape;
    beforeWasLandscape = YES;
}

- (void)setPortrait {
    popUpView.frame = windowPortrait;
    closeButton.frame = buttonPortrait;
    beforeWasLandscape = NO;
}

@end
