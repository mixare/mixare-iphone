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

#import "Matrix.h"


@implementation Matrix
@synthesize a1=_a1,a2=_a2,a3=_a3,b1=_b1,b2=_b2,b3=_b3,c1=_c1,c2=_c2,c3=_c3;
+(Matrix*) initMatrixWithA1: (float)a1 a2: (float) a2 a3:(float)a3 b1:(float)b1 b2:(float)b2 b3:(float)b3 c1:(float)c1 c2:(float)c2 c3:(float)c3{
	Matrix * mat = [[[Matrix alloc]init]autorelease];
	mat.a1 = a1;
	mat.a2 = a2;
	mat.a3 = a3;
	mat.b1 = b1;
	mat.b2 = b2;
	mat.b3 = b3;
	mat.c1 = c1;
	mat.c2 = c2;
	mat.c3 = c3;
	return  mat;
}

-(void) setMatrixWithMatrix: (Matrix*) matrix{
	self.a1= matrix.a1;
	self.a2= matrix.a2;
	self.a3= matrix.a3;
	self.b1= matrix.b1;
	self.b2= matrix.b2;
	self.b3= matrix.b3;
	self.c1= matrix.c1;
	self.c2= matrix.c2;
	self.c3= matrix.c3;
}
-(void) setToA1:(float)a1 a2: (float) a2 a3:(float)a3 b1:(float)b1 b2:(float)b2 b3:(float)b3 c1:(float)c1 c2:(float)c2 c3:(float)c3{
	self.a1= a1;
	self.a2= a2;
	self.a3= a3;
	self.b1= b1;
	self.b2= b2;
	self.b3= b3;
	self.c1= c1;
	self.c2= c2;
	self.c3= c3;
}
-(void) toIdentity{
	[self setToA1:1 a2:0 a3:0 b1:0 b2:1 b3:0 c1:0 c2:0 c3:1];
}

-(void) toXRotWithAngle: (float) angleX{
	[self setToA1:1.0 a2:0.0 a3:0.0 b1:0.0 b2:cos(angleX) b3:-sinf(angleX) c1:0.0 c2:sinf(angleX) c3:cosf(angleX)];
}
-(void) toYRotWithAngle: (float) angleY{
	[self setToA1:cosf(angleY) a2:0.0 a3:sinf(angleY) b1:0.0 b2:1.0 b3:0.0 c1:-sinf(angleY) c2:0.0 c3:cosf(angleY)];
}
-(void) toZRotWithAngle: (float) angleZ{
	[self setToA1:cosf(angleZ) a2:-sinf(angleZ) a3:0.0 b1:sinf(angleZ) b2:cosf(angleZ) b3:0.0 c1:0.0 c2:0.0 c3:1.0];
}
-(void) toScale: (float) scale{
	[self setToA1:scale a2:0.0 a3:0.0 b1:0.0 b2:scale b3:0.0 c1:0.0 c2:0.0 c3:scale];
}	

-(void) toAtWithCam: (MixVector*)cam object:(MixVector*)obj{
	MixVector * worldUp = [MixVector initWithX: 0 y:1 z:0];
	MixVector * dir = [[[MixVector alloc]init]autorelease];
	[dir setVector:obj];
	[dir subVector:cam];
	[dir multWithScalar:-1.0];
	[dir norm];
	
	MixVector* right = [[[MixVector alloc]init]autorelease];
	[right crossWithVectorA:worldUp VectorB:dir];
	[right norm];
	
	MixVector* up = [[[MixVector alloc]init]autorelease];
	[up crossWithVectorA:dir VectorB:right];
	[up norm];
	
	[self setToA1:right.x a2:right.y a3:right.z b1:up.x b2:up.y b3:up.z c1:dir.x c2:dir.y c3:dir.z];
	
}
-(float) det2x2WithA: (float) a b: (float) b c: (float) c d: (float) d{
	return (a*d) - (b*c);
}
-(float) det{
	return (_a1*_b2*_c3)-(_a1 * _b3 * _c2) - (_a2 * _b1 * _c3) + (_a2 * _b3 * _c1) + (_a3 * _b1 * _c2) - (_a3 * _b2 * _c1);
}
-(void) multWithScalar: (float) f{
	_a1 = _a1 * f;
	_a2 = _a2 * f;
	_a3 = _a3 * f;
	
	_b1 = _b1 * f;
	_b2 = _b2 * f;
	_b3 = _b3 * f;
	
	_c1 = _c1 * f;
	_c2 = _c2 * f;
	_c3 = _c3 * f;
}
-(void) addMatrix: (Matrix*) mat{
	_a1 += mat.a1;
	_a2 += mat.a2;
	_a3 += mat.a3;
	
	_b1 += mat.b1;
	_b2 += mat.b2;
	_b3 += mat.b3;
	
	_c1 += mat.c1;
	_c2 += mat.c2;
	_c3 += mat.c3;
}

-(void)adj{
	float a11 = self.a1;
	float a12 = self.a2;
	float a13 = self.a3;
	
	float a21 = self.b1;
	float a22 = self.b2;
	float a23 = self.b3;
	
	float a31 = self.c1;
	float a32 = self.c2;
	float a33 = self.c3;
	
	_a1 = [self det2x2WithA:a22 b:a23 c:a32 d:a33];
	_a2 = [self det2x2WithA:a13 b:a12 c:a33 d:a32];
	_a3 = [self det2x2WithA:a12 b:a13 c:a22 d:a23];
	
	_b1 = [self det2x2WithA:a23 b:a21 c:a33 d:a31];
	_b2 = [self det2x2WithA:a11 b:a13 c:a31 d:a33];
	_b3 = [self det2x2WithA:a13 b:a11 c:a23 d:a21];
	
	_c1 = [self det2x2WithA:a21 b:a22 c:a31 d:a32];
	_c2 = [self det2x2WithA:a12 b:a11 c:a32 d:a31];
	_c3 = [self det2x2WithA:a11 b:a12 c:a21 d:a22];
}

-(void) invert{
	float det = [self det];
	[self adj];
	[self multWithScalar:1/det];
}

-(void) transpose{
	float a11 = _a1;
	float a12 = _a2;
	float a13 = _a3;
	
	float a21 = _b1;
	float a22 = _b2;
	float a23 = _b3;
	
	float a31 = _c1;
	float a32 = _c2;
	float a33 = _c3;
	
	_b1 = a12;
	_a2 = a21;
	_b3 = a32;
	_c2 = a23;
	_c1 = a13;
	_a3 = a31;
	
	_a1 = a11;
	_b2 = a22;
	_c3 = a33;
}

-(void) prodWithMatrix: (Matrix*) n{
	Matrix* m = [[[Matrix alloc]init]autorelease];
	[m setMatrixWithMatrix:self];
	_a1 = (m.a1 * n.a1) + (m.a2 * n.b1) + (m.a3 * n.c1);
	_a2 = (m.a1 * n.a2) + (m.a2 * n.b2) + (m.a3 * n.c2);
	_a3 = (m.a1 * n.a3) + (m.a2 * n.b3) + (m.a3 * n.c3);
	
	_b1 = (m.b1 * n.a1) + (m.b2 * n.b1) + (m.b3 * n.c1);
	_b2 = (m.b1 * n.a2) + (m.b2 * n.b2) + (m.b3 * n.c2);
	_b3 = (m.b1 * n.a3) + (m.b2 * n.b3) + (m.b3 * n.c3);
	
	_c1 = (m.c1 * n.a1) + (m.c2 * n.b1) + (m.c3 * n.c1);
	_c2 = (m.c1 * n.a2) + (m.c2 * n.b2) + (m.c3 * n.c2);
	_c3 = (m.c1 * n.a3) + (m.c2 * n.b3) + (m.c3 * n.c3);
}
@end
