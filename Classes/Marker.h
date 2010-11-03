//
//  Marker.h
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhysicalPlace.h"
#import "MixVector.h"
#import "ScreenLine.h"
#import "Camera.h"
#import "Circle.h"
#import "MarkerObject.h"

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
	MarkerObject * _markerView;
	
}
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic , retain) PhysicalPlace* mGeoLoc;
@property (nonatomic, retain) MixVector* locationVector;
@property (nonatomic, retain) MarkerObject * markerView;

+(Marker*) initMarkerWithTitle: (NSString*) title latitude: (float) lat longitude: (float) lon altitude: (float) alt url: (NSString*) url;
-(void) cCMarkerWithOrigPoint: (MixVector *) originalPoint camera: (Camera*) viewCam addX: (float) addX addY: (float) addY; 
-(void) calcVWithCam: (Camera*) viewCam;
//-(void) updateLocation: (Loc
@end
