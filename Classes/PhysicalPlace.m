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

#import "PhysicalPlace.h"


@implementation PhysicalPlace

@synthesize geoLocation;

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
	float longitudinalDifference = second.longitude - first.longitude;
	float latitudinalDifference = second.latitude - first.latitude;
	float possibleAzimuth = (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
	if (longitudinalDifference > 0) return possibleAzimuth;
	else if (longitudinalDifference < 0) return possibleAzimuth + M_PI;
	else if (latitudinalDifference < 0) return M_PI;
	
	return 0.0f;
}

- (void)calibrateUsingOrigin:(CLLocation *)origin {
	
	if (!self.geoLocation) return;
	
	double baseDistance = [origin distanceFromLocation: self.geoLocation];
	
	self.radialDistance = sqrt(pow(origin.altitude - self.geoLocation.altitude, 2) + pow(baseDistance, 2));
		
	float angle = sin(ABS(origin.altitude - self.geoLocation.altitude) / self.radialDistance);
	
	if (origin.altitude > self.geoLocation.altitude) angle = -angle;
	
	self.inclination = angle;
	self.azimuth = [self angleFromCoordinate:origin.coordinate toCoordinate:self.geoLocation.coordinate];
}

+ (PhysicalPlace *)coordinateWithLocation:(CLLocation *)location {
	PhysicalPlace *newCoordinate = [[PhysicalPlace alloc] init];
	newCoordinate.geoLocation = location;
	
	newCoordinate.title = @"";
	
	return [newCoordinate autorelease];
}

+ (PhysicalPlace *)coordinateWithLocation:(CLLocation *)location fromOrigin:(CLLocation *)origin {
	PhysicalPlace *newCoordinate = [PhysicalPlace coordinateWithLocation:location];
	
	[newCoordinate calibrateUsingOrigin:origin];
		
	return newCoordinate;
}

@end
