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
