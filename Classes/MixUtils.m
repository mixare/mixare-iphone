//
//  MixUtils.m
//  Mixare
//
//  Created by jakob on 26.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MixUtils.h"


@implementation MixUtils
+(NSString*) formatDist: (float) meters{
	if(meters < 1000){
		return [NSString stringWithFormat:@" %f m",meters];
	}else if(meters < 10000){
		return [NSString stringWithFormat:@" %f km",[self formatDec: meters/1000.0 dec:1]];
	}
}
+(NSString*) formatDec: (float) val dec: (int)dec{
	int factor = (int)pow(10, dec);
	int front = (int) val;
	int back = abs(val*factor)%factor;
	return [NSString stringWithFormat:@"%i.%i",front,back];
}

+(BOOL) pointInsidePx: (float) px pY: (float) py rX: (float) rx rY: (float) ry rW: (float) rw rH: (float)rh{
	return (px > rx && px < rx + rw && py > ry && py < ry + rh);
}

+(float) getAngleFromCenter: (float) centerX centerY: (float) centerY postX: (float) postX postY: (float) postY{
	float tmpv_x = postX - centerX;
	float tmpv_y = postY - centerY;
	float d = sqrtf(tmpv_x * tmpv_x + tmpv_y * tmpv_y);
	float cos = tmpv_x / d;
	float angle = (float) (acosf(cos)* 180 / M_PI);
	
	angle = (tmpv_y < 0) ? angle * -1 : angle;
	
	return angle;
}


@end
