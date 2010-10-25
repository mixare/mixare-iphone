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

#import "Camera.h"


@implementation Camera
@synthesize width = _width, height = _height, transform = _transform, dist = _dist, lco = _lco, viewAngle = _viewAngle;

+(Camera*) initCameraWithHeight: (int) height widh: (int) width{
	Camera* cam = [[[Camera alloc]init]autorelease];
	cam.height = height;
	cam.width = width;
	return cam;
}

-(void) setViewAngle: (float) angle{
	self.viewAngle = angle;
	self.dist = (self.width/2)/tanf(angle/2);
}

-(void) setViewAngle: (float) angle height: (int) height width: (int)width{
	self.viewAngle = angle;
	self.dist = (width/2) / tanf(angle/2);
}

-(void) projectPointWithOrigin: (MixVector*) orgPoint projectPoint: (MixVector*) prjPoint addX: (float) addX addY: (float) addY{
	prjPoint.x = self.dist * orgPoint.y / -orgPoint.z;
	prjPoint.y = self.dist * orgPoint.y / -orgPoint.z;
	prjPoint.z = orgPoint.z;
	prjPoint.x = prjPoint.x + addX + self.width / 2;
	prjPoint.y = -prjPoint.y + addY + self.height / 2;
}



@end
