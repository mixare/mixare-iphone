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

#import "PoiItem.h"

@implementation PoiItem

@synthesize radialDistance, inclination, azimuth;
@synthesize radarPos = _radarPos, position, geoLocation;

- (id)initCoordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth {
	self = [super init];
	radialDistance = newRadialDistance;
	inclination = newInclination;
	azimuth = newAzimuth;
	return self;
}

- (id)initWithLatitude:(float)lat longitude:(float)lon altitude:(CGFloat)alt position:(Position*)pos {
    self = [super init];
    geoLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:alt horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
    position = pos;
    return self;
}

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
	float longitudinalDifference = second.longitude - first.longitude;
	float latitudinalDifference = second.latitude - first.latitude;
	float possibleAzimuth = (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
	if (longitudinalDifference > 0) return possibleAzimuth;
	else if (longitudinalDifference < 0) return possibleAzimuth + M_PI;
	else if (latitudinalDifference < 0) return M_PI;
	return 0.0f;
}

- (void)calibrateUsingOrigin:(CLLocation*)origin {
	if (!geoLocation) return;
	double baseDistance = [origin distanceFromLocation: geoLocation];
	self.radialDistance = sqrt(pow(origin.altitude - geoLocation.altitude, 2) + pow(baseDistance, 2));
	float angle = sin(ABS(origin.altitude - geoLocation.altitude) / self.radialDistance);
	if (origin.altitude > geoLocation.altitude) angle = -angle;
	self.inclination = angle;
	self.azimuth = [self angleFromCoordinate:origin.coordinate toCoordinate:geoLocation.coordinate];
}

@end
