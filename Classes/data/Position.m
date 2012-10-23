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
//
//  Position.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//

#import "Position.h"

@implementation Position

@synthesize mapViewAnnotation, poiItem, title, summary, url, source;

- (Position*)initWithTitle:(NSString*)tit withSummary:(NSString*)sum withUrl:(NSString*)u withLatitude:(float)lat withLongitude:(float)lon withAltitude:(CGFloat)alt withSource:(NSString*)sour {
    self = [super init];
    if(self) {
        title = tit;
        summary = sum;
        url = u;
        latitude = lat;
        longitude = lon;
        altitude = alt;
        source = sour;
        [self initMarkerAndMapAnnotation];
    }
    return self;
}

- (void)initMarkerAndMapAnnotation {
    mapViewAnnotation = [[MapViewAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
    [mapViewAnnotation setTitle:title];
    [mapViewAnnotation setSubTitle:summary];
    CLLocation *tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:altitude horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
    poiItem = [[PhysicalPlace alloc] coordinateWithLocation:tempLocation];
    [poiItem setTitle:title];
    [poiItem setUrl:url];
    [poiItem setSource:source];
}

- (void)dealloc {
    [super dealloc];
    [mapViewAnnotation release];
    [poiItem release];
}

@end
