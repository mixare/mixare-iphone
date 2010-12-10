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
#import "PoiItem.h"


@implementation PoiItem

@synthesize radialDistance, inclination, azimuth;

@synthesize title  , subtitle , source= _source , url = _url, radarPos = _radarPos;

+ (PoiItem *)coordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth {
	PoiItem *newCoordinate = [[PoiItem alloc] init];
	newCoordinate.radialDistance = newRadialDistance;
	newCoordinate.inclination = newInclination;
	newCoordinate.azimuth = newAzimuth;
	
	newCoordinate.title = @"";
	
	return [newCoordinate autorelease];
}

- (NSUInteger)hash{
	return ([self.title hash] ^ [self.subtitle hash]) + (int)(self.radialDistance + self.inclination + self.azimuth);
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToCoordinate:other];
}

- (BOOL)isEqualToCoordinate:(PoiItem *)otherCoordinate {
    if (self == otherCoordinate) return YES;
    
	BOOL equal = self.radialDistance == otherCoordinate.radialDistance;
	equal = equal && self.inclination == otherCoordinate.inclination;
	equal = equal && self.azimuth == otherCoordinate.azimuth;
		
	if (self.title && otherCoordinate.title || self.title && !otherCoordinate.title || !self.title && otherCoordinate.title) {
		equal = equal && [self.title isEqualToString:otherCoordinate.title];
	}
	
	return equal;
}

- (void)dealloc {
	
	self.title = nil;
	self.subtitle = nil;
	
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ r: %.3fm φ: %.3f° θ: %.3f°", self.title, self.radialDistance, radiansToDegrees(self.azimuth), radiansToDegrees(self.inclination)];
}

@end
