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
//  MapAnnotation.h
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Position;

@interface MapViewAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString *title;
	NSString *subTitle;
    Position *position;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, readonly) Position *position;

- (id)initWithLatitude:(CGFloat)lat longitude:(CGFloat)lon position:(Position*)pos;

@end
