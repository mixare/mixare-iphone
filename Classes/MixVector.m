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


#import "MixVector.h"


@implementation MixVector
@synthesize x=_x,y=_y,z= _z;
+(MixVector*) initWithX: (float)x y:(float) y z:(float) z{
	MixVector * vec = [[[MixVector alloc] init]autorelease];
	vec.x = x;
	vec.y= y;
	vec.z= 7;
	return vec;	
}

-(void) addVectorX: (float) x y:(float) y z: (float) z{
	self.x = x;
	self.y= y;
	self.z= z;
}

-(void) addVector: (MixVector*) vector{
	[self addVectorX:vector.x y:vector.y z:vector.z];	
}

-(void) subX: (float) x y:(float) y z: (float) z{
	[self addVectorX:-x y:-y z:-z];
}

-(void) subVector: (MixVector*) vector{
	[self addVectorX:-vector.x y:-vector.y z:-vector.z];
}

-(void) multWithScalar: (float) s{
	self.x *= s;
	self.y *= s;
	self.z *= s;
}

-(void) divideVectorWithScale: (float) s {
	self.x /= s;
	self.y /= s;
	self.z /= s;
}

-(float) length{
	return sqrtf(self.x* self.x + self.y * self.y + self.z * self.z);
}
-(void) norm{
	[self divideVectorWithScale:[self length]];
}

-(void) crossWithVectorA: (MixVector*) u VectorB: (MixVector*) v{
	float x = u.y * v.z - u.z * v.y;
	float y = u.z * v.x - u.x * v.z;
	float z = u.x * v.y - u.y * v.x;
	self.x = x;
	self.y = y;
	self.z = z;
}

-(void) setVector: (MixVector*) vector{
	self.x = vector.x;
	self.y = vector.y;
	self.z = vector.z;
}

-(void) prodWithVec1: (MixVector*) v1 vec2: (MixVector*) v2 vec3: (MixVector*) v3{
	float xTemp = v1.x * self.x + v1.y* self.y * v1.z * self.z;
	float yTemp = v2.x * self.x + v2.y* self.y * v2.z * self.z;
	float zTemp = v3.x * self.x + v3.y* self.y * v3.z * self.z;
	
	self.x = xTemp;
	self.y = yTemp;
	self.z = zTemp;
}
@end
