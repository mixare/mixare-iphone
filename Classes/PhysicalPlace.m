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

