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

#import <Foundation/Foundation.h>
#import "PoiItem.h"
#import <CoreLocation/CoreLocation.h>
@class Position;

//This class is used to represent a physically place in a virtual world. 
@interface PhysicalPlace : PoiItem {
	CLLocation *geoLocation;
}

@property (nonatomic, strong) CLLocation *geoLocation;

//calculates the angle between two coordinates
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second;
- (PhysicalPlace*)initWithLatitude:(float)lat longitude:(float)lon altitude:(CGFloat)alt position:(Position*)pos;

//initializer returns a physicalplace with his location
- (PhysicalPlace*)initCoordinateWithLocation:(CLLocation*)location;

- (void)calibrateUsingOrigin:(CLLocation*)origin;
- (PhysicalPlace*)initCoordinateWithLocation:(CLLocation*)location fromOrigin:(CLLocation*)origin;

@end
