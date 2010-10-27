//
//  ScreenLine.m
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "ScreenLine.h"


@implementation ScreenLine
@synthesize x = _x, y = _y;

-(void)setWithX: (float) x y: (float) y{
	_x = x;
	_y = y;
}

-(void) rotateWithValue: (float) t{
	float xp = cosf(t) * _x - sinf(t)*_y;
	float yp = sinf(t) * _x - cosf(t)*_y;
	_x= xp;
	_y=yp;
}

-(void) addX: (float) x y: (float) y{
	_x  += x;
	_y  += y;
}


@end
