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

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * (180.0/M_PI))

@class ARCoordinate;

@protocol ARPersistentItem

@property (nonatomic, readonly) ARCoordinate *arCoordinate;

@optional

// Title and subtitle for use by selection UI.
- (NSString *)title;
- (NSString *)subtitle;

@end


@protocol ARGeoPersistentItem

// Center latitude and longitude of the annotion view.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

// Title and subtitle for use by selection UI.
- (NSString *)title;
- (NSString *)subtitle;

@end


@interface ARCoordinate : NSObject {
	double radialDistance;
	double inclination;
	double azimuth;
	NSString *_source;
	NSString *title;
	NSString *subtitle;
}

- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToCoordinate:(ARCoordinate *)otherCoordinate;

+ (ARCoordinate *)coordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSString * source;
@property (nonatomic) double radialDistance;
@property (nonatomic) double inclination;
@property (nonatomic) double azimuth;

@end
