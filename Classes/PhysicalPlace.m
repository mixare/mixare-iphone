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

#import "PhysicalPlace.h"


@implementation PhysicalPlace
@synthesize coordinate;
@synthesize lat=_lat,lon=_lon,altitude= _altitude;
@synthesize subTitle= _subTitle, title= _title;

#pragma mark methods for class PhysicalPlace
-(PhysicalPlace*)intWithLatitude: (CGFloat) latitude longitude: (CGFloat) longitude altitude: (CGFloat) alt title: (NSString*) title subTitle: (NSString*) subTitle{
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

CGFloat degreesToRadians(CGFloat degrees){
	return degrees * M_PI / 180;
};

CGFloat radiansToDegrees(CGFloat radians){
	return radians * 180 / M_PI;
};

+(void)calcDestinationWithLat1: (CGFloat) lat1Deg lon1: (CGFloat) lon1Deg bear: (CGFloat) bear destination: (CGFloat) d place: (PhysicalPlace*) pl{
	CGFloat brng = degreesToRadians(bear) ;
	CGFloat lat1 = degreesToRadians(lat1Deg);
	CGFloat lon1 = degreesToRadians(lon1Deg);
	CGFloat R =  6371.0 * 1000.0; 
	CGFloat lat2 = asinf((sinf(lat1)* cosf(d/R)) + (cosf(lat1)* sinf(d/R) * cosf(brng)));
	CGFloat lon2 = lon1 + atan2f(sinf(brng) * sinf(d/R) * cosf(lat1) , cosf(d/R) - sinf(lat1)*sinf(lat2));
	[pl setLat:radiansToDegrees(lat2)];
	[pl setLon:radiansToDegrees(lon2)];
}
+(CGFloat)distanceBetweenLong1: (CGFloat) long1 lat1: (CGFloat) lat1 long2: (CGFloat)long2 lat2: (CGFloat)lat2{
	CGFloat r = 6371.0 * 1000.0;
	CGFloat deltaLat= degreesToRadians(lat2-lat1);
	CGFloat deltaLon = degreesToRadians(long2 - long1);
	CGFloat a = sinf(deltaLat/2)*sinf(deltaLat/2)+ cosf(degreesToRadians(lat1))*cosf(degreesToRadians(lat2))*sinf(deltaLon/2)*sinf(deltaLon/2);
	CGFloat c = 2* atan2f(sqrtf(a),sqrtf(1-a));
	return  r*c;
}

+(MixVector*)convLocToVecWithLocation: (CLLocation*) org place: (PhysicalPlace*) gp {
	//CLLocation * gpToLoc = [[[CLLocation alloc]initWithLatitude:gp.lat longitude:gp.lon]autorelease];
	CGFloat distanceZ = [self distanceBetweenLong1:org.coordinate.longitude lat1:org.coordinate.latitude long2:gp.lon lat2:gp.lat];
	CGFloat distanceX = [self distanceBetweenLong1:org.coordinate.longitude lat1:org.coordinate.latitude long2:gp.lon lat2:org.coordinate.latitude];
	CGFloat y = gp.altitude - org.altitude;
	if(org.coordinate.latitude >gp.lat){
		distanceZ = distanceZ*-1.0;
	}
	if(org.coordinate.longitude > gp.lon){
		distanceX = distanceX*-1;
	}
	return [MixVector initWithX:distanceX y:y z:distanceZ];   
}

+(void) convVec: (MixVector*)v toLocation:(CLLocation*) org gp: (CLLocation*)gp{
	CGFloat brngNS = 0;
	CGFloat brngEW = 90;
	if(v.z>0){
		brngNS = 180;
	}
	if(v.x <0) {
		brngEW = 270;
	}
	PhysicalPlace * tmp1Loc = [[[PhysicalPlace alloc]init]autorelease];
	PhysicalPlace * tmp2Loc = [[[PhysicalPlace alloc]init]autorelease];
	[PhysicalPlace calcDestinationWithLat1:org.coordinate.latitude lon1:org.coordinate.longitude bear:brngNS destination:abs(v.z) place:tmp2Loc];
	[PhysicalPlace calcDestinationWithLat1:tmp1Loc.lat lon1:tmp1Loc.lon bear:brngEW destination:abs(v.x) place:tmp2Loc];
	[gp initWithCoordinate:CLLocationCoordinate2DMake(tmp2Loc.lat, tmp2Loc.lon) altitude:org.altitude+v.y horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
	//gp.altitude = org.altitude + v.y;
}


-(void)dealloc {
	[self.title release];
	[self.subTitle release];
    [super dealloc];
}


#pragma mark MKAnnotation protocol
- (CLLocationCoordinate2D)coordinate;{
    CLLocationCoordinate2D position;
	if (_lat != 0.0 && _lon != 0.0) {
		position.latitude = _lat;
		position.longitude = _lon;
	}else {
		position.latitude=0.0;
		position.longitude=0.0;
	}
	
    return position; 
}
@end

