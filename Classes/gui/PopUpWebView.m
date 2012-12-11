//
//  PopUpWebView.m
//  Mixare
//
//  Created by Aswin Ly on 11-12-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "PopUpWebView.h"

@implementation PopUpWebView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        self.alpha = 0.0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self setAlpha:.7];
        [UIView commitAnimations];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
