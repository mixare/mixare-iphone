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

@implementation PopUpWebView

- (id)initWithMainView:(UIView*)view padding:(int)pad isTabbar:(BOOL)tab rotateable:(BOOL)rotate {
    self = [super init];
    if (self) {
        mainView = view;
        rotateable = rotate;
        int tabBar = 0;
        if (tab) {
            tabBar = 70;
        } 
        windowPortrait = CGRectMake(pad, pad,
                                    [UIScreen mainScreen].bounds.size.width - (pad * 2),
                                    [UIScreen mainScreen].bounds.size.height - tabBar - (pad * 2));
        buttonPortrait = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50,
                                    [UIScreen mainScreen].bounds.size.height - tabBar - 35,
                                    100, 35);
        
        windowLandscape = CGRectMake(pad, pad,
                                    [UIScreen mainScreen].bounds.size.height - (pad * 2),
                                    [UIScreen mainScreen].bounds.size.width - tabBar - (pad * 2));
        buttonLandscape = CGRectMake([UIScreen mainScreen].bounds.size.height / 2 - 50,
                                    [UIScreen mainScreen].bounds.size.width - tabBar - 35,
                                    100, 35);
        
        if (rotateable) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didRotate:)
                                                     name:@"UIDeviceOrientationDidChangeNotification"
                                                   object:nil];
        }
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
    if (rotateable && (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))) {
        windowDimension = windowLandscape;
        buttonDimension = buttonLandscape;
    }
    popUpView = [[UIWebView alloc] initWithFrame:windowDimension];
    [popUpView setBackgroundColor:[UIColor blackColor]];
    popUpView.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [popUpView setAlpha:.6];
    [UIView commitAnimations];
    
    NSURL *requestURL = [NSURL URLWithString:url];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
	[popUpView loadRequest:requestObj];
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.text = @"Close";
    closeButton.alpha = 1;
    closeButton.titleLabel.textColor = [UIColor blackColor];
    closeButton.frame = buttonDimension;
    [mainView addSubview:popUpView];
    [mainView addSubview:closeButton];
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
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
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
