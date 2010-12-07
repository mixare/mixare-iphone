//
//  RadarViewPortView.m
//  Mixare
//
//  Created by Obkircher Jakob on 23.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "RadarViewPortView.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation RadarViewPortView
@synthesize newAngle, referenceAngle;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    self.backgroundColor = [UIColor clearColor];
    isFirstAccess = YES;
    newAngle = 45.0;
    referenceAngle = 247.5;
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 115, 0.3);
    
    // view port 
//    if(isFirstAccess){
        CGContextMoveToPoint(contextRef, RADIUS, RADIUS);
        CGContextAddArc(contextRef, RADIUS, RADIUS, RADIUS,  radians(referenceAngle), radians(referenceAngle+newAngle),0); 
        CGContextClosePath(contextRef); 
        CGContextFillPath(contextRef);
//    }
    isFirstAccess = NO;
}


- (void)dealloc {
    [super dealloc];
}


@end
