//
//  Matrix.h
//  Mixare
//
//  Created by jakob on 22.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

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