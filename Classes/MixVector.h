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

#import <Foundation/Foundation.h>

@interface MixVector : NSObject {
	float _x;
	float _y;
	float _z;
}
@property (nonatomic) float x,y,z;

+(MixVector*) initWithX: (float)x y:(float) y z:(float) z;
-(void) addVectorX: (float) x y:(float) y z: (float) z;
-(void) addVector: (MixVector*) vector;
-(void) subX: (float) x y:(float) y z: (float) z;
-(void) subVector: (MixVector*) vector;
-(void) multWithScalar: (float) s;
-(void) divideVectorWithScale: (float) s ;
-(float) length;
-(void) norm;
-(void) crossWithVectorA: (MixVector*) u VectorB: (MixVector*) v;
-(void) setVector: (MixVector*) vector;
-(void) prodWithVec1: (MixVector*) v1 vec2: (MixVector*) v2 vec3: (MixVector*) v3;

@end