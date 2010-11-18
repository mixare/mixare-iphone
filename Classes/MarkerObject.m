/* Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/> */

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
	
    CGContextShowTextAtPoint(ctx, 15, 40, text, strlen(text));
}


- (void)dealloc {
    [super dealloc];
}


@end
