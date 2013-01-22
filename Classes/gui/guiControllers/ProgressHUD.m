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
//  ProgressHUD.m
//  Mixare
//
//  Created by Aswin Ly on 22-11-12.
//

#import "ProgressHUD.h"
#import "Resources.h"

@implementation ProgressHUD

@synthesize backgroundImageView, activityIndicator, progressMessage, appDelegate;

- (id)initWithLabel:(NSString *)text {
    self = [super init];
    if (self) {
        self.appDelegate = (MixareAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[Resources getInstance] bundle] pathForResource:@"HUDBackground" ofType:@"png"]] ];
		backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
		[self addSubview:backgroundImageView];
        
        progressMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        progressMessage.textColor = [UIColor whiteColor];
        progressMessage.backgroundColor = [UIColor clearColor];
		progressMessage.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
        progressMessage.text = text;
		progressMessage.textAlignment = NSTextAlignmentCenter;
		progressMessage.adjustsFontSizeToFitWidth = YES;
		progressMessage.numberOfLines = 2;
        [self addSubview:progressMessage];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
}

- (void)layoutSubviews {
    [progressMessage sizeToFit];
	
	progressMessage.center = backgroundImageView.center;
	activityIndicator.center = backgroundImageView.center;
    
    CGRect textRect = progressMessage.frame;
    textRect.origin.y += 30.0;
	textRect.origin.x = backgroundImageView.frame.origin.x + 5;
	textRect.size.width = backgroundImageView.frame.size.width - 10;
	textRect.size.height += textRect.size.height;
    progressMessage.frame = textRect;
	
    
    CGRect activityRect = activityIndicator.frame;
    activityRect.origin.y -= 10.0;
    activityIndicator.frame = activityRect;
	
    [self bringSubviewToFront:activityIndicator];
    [self bringSubviewToFront:progressMessage];
}

- (void)show {
    [super show];
    CGSize backGroundImageSize = self.backgroundImageView.image.size;
    self.bounds = CGRectMake(0, 0, backGroundImageSize.width, backGroundImageSize.height);
	[self layoutSubviews];
    //[self.appDelegate setAlertRunning:YES];
    [self bringSubviewToFront:activityIndicator];
    [self bringSubviewToFront:progressMessage];
}

- (void)dismiss {
    [super dismissWithClickedButtonIndex:0 animated:YES];
    //[self.appDelegate setAlertRunning:NO];
}

// Wrapper to dismiss in main thread
- (void)realDismissWithArgs:(NSArray *)args {
    NSInteger buttonIndex = [[args objectAtIndex:0] intValue];
    BOOL animated = [[args objectAtIndex:1] boolValue];
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    // We can only interact with UIKit from the main thread
    [super performSelectorOnMainThread:@selector(realDismissWithArgs:)
                            withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:buttonIndex], [NSNumber numberWithBool:animated],nil]
                         waitUntilDone:YES];
    //[self.appDelegate setAlertRunning:NO];
}

@end
