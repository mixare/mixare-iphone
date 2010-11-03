//
//  MarkerObject.m
//  Mixare
//
//  Created by jakob on 29.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MarkerObject.h"


@implementation MarkerObject
@synthesize text = _text;
@synthesize circle = _circle;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
		_circle = [[Circle alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
		[self addSubview:_circle];
		[_circle release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    char* text = [_text cString];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSelectFont(ctx, "Helvetica", 14.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetRGBFillColor(ctx, 0, 255, 255, 1);
	
    CGAffineTransform xform = CGAffineTransformMake(
													1.0,  0.0,
													0.0, -1.0,
													0.0,  0.0);
    CGContextSetTextMatrix(ctx, xform);
	
    CGContextShowTextAtPoint(ctx, 10, 40, text, strlen(text));
}


- (void)dealloc {
    [super dealloc];
}


@end
