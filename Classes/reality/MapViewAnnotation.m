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
//  MapAnnotation.m
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate, position;
@synthesize subTitle, title;

- (id)initWithLatitude:(CGFloat)lat longitude:(CGFloat)lon position:(Position *)pos {
    self = [super init];
    if (self) {
        if (lat != 0.0 && lon != 0.0) {
            coordinate.latitude = lat;
            coordinate.longitude = lon;
        } else {
            coordinate.latitude = 0.0;
            coordinate.longitude = 0.0;
        }
    position = pos;
    }
    return self;
}

@end