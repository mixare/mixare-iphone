//
//  PhysicalPlace.m
//  Mixare
//
//  Created by jakob on 21.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhysicalPlace.h"


@implementation PhysicalPlace
@synthesize coordinate;
@synthesize lat,lon,altitude;
@synthesize subTitle, title;

#pragma mark methods for class PhysicalPlace
-(PhysicalPlace*)intWithLatitude: (NSString*) latitude longitude: (NSString*) longitude altitude: (NSString*) alt title: (NSString*) title subTitle: (NSString*) subTitle{
	PhysicalPlace * place = [[[PhysicalPlace alloc]init]autorelease];
	place.lat = latitude;
	place.lon = longitude;
	place.altitude = alt;
	place.title = title;
	place.subTitle= subTitle;
	return  place;
}

-(void)setDataWithPlace: (PhysicalPlace*)place{
	self.lon = place.lon;
	self.lat = place.lat;
	self.altitude = place.altitude;
}

/*
public static void calcDestination(double lat1Deg, double lon1Deg,
								   double bear, double d, PhysicalPlace dest) {
	/** see http://en.wikipedia.org/wiki/Great-circle_distance */
	
/*	double brng = Math.toRadians(bear);
	double lat1 = Math.toRadians(lat1Deg);
	double lon1 = Math.toRadians(lon1Deg);
	double R = 6371.0 * 1000.0; 
	
	double lat2 = Math.asin(Math.sin(lat1) * Math.cos(d / R)
							+ Math.cos(lat1) * Math.sin(d / R) * Math.cos(brng));
	double lon2 = lon1
	+ Math.atan2(Math.sin(brng) * Math.sin(d / R) * Math.cos(lat1),
				 Math.cos(d / R) - Math.sin(lat1) * Math.sin(lat2));
	
	dest.setLatitude(Math.toDegrees(lat2));
	dest.setLongitude(Math.toDegrees(lon2));
}*/

+(void)calcDestinationWithLat1: (float) lat1Deg lon1: (float) lon1Deg bear: (float) bear destination: (float) d place: (PhysicalPlace*) pl{
	//float brng = degreesToRadiants(bear);
}

+ (float)degreesToRadians:(float)degrees{
	return degrees / 57.2958;
}

-(void)dealloc {
    [self.lat release];
	[self.lon release];
	[self.altitude release];
	[self.title release];
	[self.subTitle release];
    [super dealloc];
}


#pragma mark MKAnnotation protocol
- (CLLocationCoordinate2D)coordinate;{
    CLLocationCoordinate2D position;
	if (lat != nil && lon != nil) {
		position.latitude = [lat floatValue];
		position.longitude = [lon floatValue];
	}else {
		position.latitude=0.0;
		position.longitude=0.0;
	}
	
    return position; 
}

-(NSString*)title{
	return title;
}
-(NSString*)subTitle{
	return subTitle;
}
@end

