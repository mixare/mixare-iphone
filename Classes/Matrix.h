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
#import "MixVector.h"

@interface Matrix : NSObject {
	float _a1, _a2, _a3;
	float _b1, _b2, _b3;
	float _c1, _c2, _c3;
}
@property (nonatomic) float a1,a2,a3,b1,b2,b3,c1,c2,c3;
+(Matrix*) initMatrixWithA1: (float)a1 a2: (float) a2 a3:(float)a3 b1:(float)b1 b2:(float)b2 b3:(float)b3 c1:(float)c1 c2:(float)c2 c3:(float)c3;
-(void) setMatrixWithMatrix: (Matrix*) matrix;
-(void) toIdentity;
-(void) setToA1:(float)a1 a2: (float) a2 a3:(float)a3 b1:(float)b1 b2:(float)b2 b3:(float)b3 c1:(float)c1 c2:(float)c2 c3:(float)c3;
-(void) toXRotWithAngle: (float) angleX;
-(void) toYRotWithAngle: (float) angleY;
-(void) toZRotWithAngle: (float) angleZ;
-(void) toScale: (float) scale;
//-(void) toAtWithCam: (MixVector*) cam object:(MixVector*) obj;
-(void) adj;
-(float) det2x2WithA: (float) a b: (float) b c: (float) c d: (float) d;
-(float) det;
-(void) multWithScalar: (float) f;
-(void) addMatrix: (Matrix*) m;
-(void) invert;
-(void) transpose;
-(void) prodWithMatrix: (Matrix*) n;

@end