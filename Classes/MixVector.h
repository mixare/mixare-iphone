//
//  MixVector.h
//  Mixare
//
//  Created by jakob on 22.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"

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
-(void) multVecotr: (MixVector*) vector;
-(void) multWithScalar: (float) s;
-(void) divideVectorWithScale: (float) s ;
-(void) length;
-(void) norm;
-(void) crossWithVectorA: (MixVector*) u VectorB: (MixVector*) v;
-(void) setVector: (MixVector*) vector;
//-(void) prodWithMat: (Matrix*) m;

@end


