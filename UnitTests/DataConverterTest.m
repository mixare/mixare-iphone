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
//  DataConverterTest.m
//  Mixare
//
//  Created by Aswin Ly on 16-10-12.
//

#import "DataConverterTest.h"


@implementation DataConverterTest

- (void)setUp {
    [super setUp];
    wikipedia = [[DataSource alloc] initTitle:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG" locked:NO];
    [wikipedia setActivated:YES];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testConvertData {
    CLLocation *location = [[[CLLocationManager alloc] init] location];
    [[DataConverter getInstance] convertData:wikipedia currentLocation:location currentRadius:3.5];
    BOOL check = YES;
    if (wikipedia.positions.count == 0) {
        check = NO;
    }
    STAssertTrue(check, @"No positions found");
}

@end
