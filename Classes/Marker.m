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

+(Marker*) initMarkerWithTitle: (NSString*) title latitude: (float) lat longitude: (float) lon altitude: (float) alt url: (NSString*) url{
	Marker * marker = [[[Marker alloc]init]autorelease];
	marker.title = title;
	marker.mGeoLoc = [[[PhysicalPlace alloc]init]autorelease];
	marker.mGeoLoc.lat = lat;
	marker.mGeoLoc.lon = lon;
	marker.url = url;
	return marker;
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
	[viewCam projectPointWithOrigin:tmpc projectPoint:tmpb addX:addX addY:addY];
	[signMarker setVector:tmpb];
}

-(void) calcVWithCam: (Camera*) viewCam{
	isVisible = NO;
	if(cMarker.z < -1.0){
		isVisible = YES;
	}
}

@end
