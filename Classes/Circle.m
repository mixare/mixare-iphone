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
