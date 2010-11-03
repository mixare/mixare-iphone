//
//  Circle.m
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"


@implementation Circle


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}
- (void)drawRect:(CGRect)rect {
	//Get the CGContext from this view
	CGContextRef context = UIGraphicsGetCurrentContext();
	// stroke and fill black with a 0.5 alpha
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 255.0, 1.0);
	CGContextSetLineWidth(context, 1.0);
	CGContextSetAllowsAntialiasing(context, YES);
	CGContextSetPatternPhase(context, CGSizeMake(2, 2));
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
	CGContextStrokeEllipseInRect(context, rect);
	// now draw the circle
	CGContextFillEllipseInRect (context, rect);
}

@end
