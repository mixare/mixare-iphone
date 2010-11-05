//
//  Marker.m
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Marker.h"


@implementation Marker
@synthesize title = _title, url = _url;
@synthesize mGeoLoc = _mGeoLoc;
@synthesize locationVector = _locationVector;
@synthesize markerView = _markerView;

+(Marker*) initMarkerWithTitle: (NSString*) title latitude: (float) lat longitude: (float) lon altitude: (float) alt url: (NSString*) url{
	Marker * marker = [[[Marker alloc]init]autorelease];
	[marker initMarker];
	marker.title = title;
	//marker.mGeoLoc = [[[PhysicalPlace alloc]init]autorelease];
	marker.mGeoLoc.lat = lat;
	marker.mGeoLoc.lon = lon;
	marker.mGeoLoc.altitude = alt;
	marker.url = url;
	//marker.markerView = [[MarkerObject alloc]init];
	marker.markerView.text = title;
	
	//marker.
	return marker;
}

-(void) initMarker{
	_title = [[NSString alloc]init];
	_url = [[NSString alloc] init];
	_mGeoLoc = [[PhysicalPlace alloc]init];
	cMarker = [[MixVector alloc]init];
	signMarker = [[MixVector alloc]init];
	tmpa = [[MixVector alloc ]init];
	tmpb = [[MixVector alloc]init];
	tmpc = [[MixVector alloc]init];
	_locationVector =[[MixVector alloc]init];
	origin =[[MixVector alloc]init];
	upV = [[MixVector alloc]init];
	pPt = [[ScreenLine alloc]init];
	_markerView = [[MarkerObject alloc]init];
}
- (void)dealloc {
	[_url release];
	[_title release];
	[_mGeoLoc release];
	[cMarker release];
	[signMarker release];
	[tmpa release];
	[tmpb release];
	[tmpc release];
	[_locationVector release];
	[origin release];
	[upV release];
	[pPt release];
	[txtLab release];
    [super dealloc];
}

-(void) cCMarkerWithOrigPoint: (MixVector *) originalPoint camera: (Camera*) viewCam addX: (float) addX addY: (float) addY{
	tmpa = [[[MixVector alloc]init]autorelease];
	[tmpa setVector:originalPoint];
	tmpc = [[[MixVector alloc]init]autorelease];
	[tmpc setVector:upV];
	[tmpa addVector:_locationVector];
	[tmpa subVector:viewCam.lco];
	[tmpc subVector:viewCam.lco];
	[tmpa prodWithVec1:[MixVector initWithX:viewCam.transform.a1 y:viewCam.transform.a2 z:viewCam.transform.a3] vec2:[MixVector initWithX:viewCam.transform.b1 y:viewCam.transform.b2 z:viewCam.transform.b3] vec3:[MixVector initWithX:viewCam.transform.c1 y:viewCam.transform.c2 z:viewCam.transform.c3]];
	[tmpc prodWithVec1:[MixVector initWithX:viewCam.transform.a1 y:viewCam.transform.a2 z:viewCam.transform.a3] vec2:[MixVector initWithX:viewCam.transform.b1 y:viewCam.transform.b2 z:viewCam.transform.b3] vec3:[MixVector initWithX:viewCam.transform.c1 y:viewCam.transform.c2 z:viewCam.transform.c3]];
	[viewCam projectPointWithOrigin:tmpa projectPoint:tmpb addX:addX addY:addY];
	[cMarker setVector:tmpb];
	//[viewCam projectPointWithOrigin:tmpc projectPoint:tmpb addX:addX addY:addY];
	[signMarker setVector:tmpb];
}

-(void) calcVWithCam: (Camera*) viewCam{
	isVisible = NO;
	if(cMarker.z < -1.0)
		isVisible = YES;
}

-(void) updateWithLocation: (CLLocation*) curGPSFix{
	if([self mGeoLoc].altitude == 0.0){
		_mGeoLoc.altitude= curGPSFix.altitude;
		[PhysicalPlace convLocToVecWithLocation:curGPSFix place:_mGeoLoc vector:_locationVector];
	}
}

-(void) calcpaintWithCamera: (Camera*) viewCam addX: (float) addX addY: (float) addY{
	[self cCMarkerWithOrigPoint:origin camera:viewCam addX:addX addY:addY];
	[self calcVWithCam:viewCam];
}

-(BOOL) isClickValidX: (float) x Y: (float) y{
	float currentAngle = [Marker getAngleFromCenter:cMarker.x centerY:cMarker.y postX:signMarker.x postY:signMarker.y];
	
	pPt.x = x - signMarker.x;
	pPt.y = y - signMarker.y;
	[pPt rotateWithValue:((-(currentAngle+90))* M_PI / 180)];
	
	pPt.x += txtLab.frame.origin.x;
	pPt.y += txtLab.frame.origin.y;
	
	float objX = txtLab.frame.origin.x - txtLab.frame.size.width / 2;
	float objY = txtLab.frame.origin.y - txtLab.frame.size.height / 2;
	float objW = txtLab.frame.size.width;
	float objH = txtLab.frame.size.height;
	
	if (pPt.x > objX && pPt.x < objX + objW && pPt.y > objY && pPt.y < objY + objH) {
		return true;
	} else {
		return false;
	}
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
