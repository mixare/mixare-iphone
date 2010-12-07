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

#import <UIKit/UIKit.h>
#import "PhysicalPlace.h"
#import "MixVector.h"
#import "ScreenLine.h"
#import "Camera.h"
#import "Circle.h"


@interface Marker : NSObject {
	NSString * _title;
	NSString * _url;
	PhysicalPlace * _mGeoLoc;
	BOOL isVisible;
	MixVector *cMarker;
	MixVector * signMarker;
	MixVector * tmpa;
	MixVector * tmpb;
	MixVector * tmpc;
	MixVector * _locationVector;
	MixVector * origin;
	MixVector * upV;
	ScreenLine * pPt;
	UILabel * txtLab; 
	//MarkerObject * _markerView;
	
	
}
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic , retain) PhysicalPlace* mGeoLoc;
@property (nonatomic, retain) MixVector* locationVector;
//@property (nonatomic, retain) MarkerObject * markerView;


+(Marker*) initMarkerWithTitle: (NSString*) title latitude: (float) lat longitude: (float) lon altitude: (float) alt url: (NSString*) url;
-(MixVector*) cCMarkerWithOrigPoint: (MixVector *) originalPoint rotM: (Matrix*) transform addX: (float) addX addY: (float) addY;
-(void) calcVWithCam: (Camera*) viewCam;
-(void) updateWithLocation: (CLLocation*) curGPSFix;
-(void) calcpaintWithCamera: (Camera*) viewCam addX: (float) addX addY: (float) addY;
-(BOOL) isClickValidX: (float) x Y: (float) y;
+(float) getAngleFromCenter: (float) centerX centerY: (float) centerY postX: (float) postX postY: (float) postY;
-(void) initMarker;
-(void) projectPointWithOrigin: (MixVector*) orgPoint projectPoint: (MixVector*) prjPoint addX: (float) addX addY: (float) addY;
@end

