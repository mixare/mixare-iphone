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

//This class represents a POI with all the needed information
@class PoiItem;

@protocol ARPersistentItem

@property (nonatomic, readonly) PoiItem *arCoordinate;

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


@interface PoiItem : NSObject {
    //distance from device to poi
	double radialDistance;
	double inclination;
    //value of how many degrees the poi is away from north in radiants
	double azimuth;
    //associated url to the poi (wikipedia, buzz …)
    NSString *_url;
    //string which describes from which source the poi comes from (WIKIPEDIA, BUZZ, TWITTER, MIXARE)
	NSString *_source;
    //title of the poi
	NSString *title;
    //subtitle of the poi
	NSString *subtitle;
}

- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToCoordinate:(PoiItem *)otherCoordinate;

+ (PoiItem *)coordinateWithRadialDistance:(double)newRadialDistance inclination:(double)newInclination azimuth:(double)newAzimuth;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSString * source;
@property (nonatomic) double radialDistance;
@property (nonatomic) double inclination;
@property (nonatomic) double azimuth;
@property (nonatomic, retain) NSString * url;
@property (nonatomic) CGPoint radarPos;

@end
