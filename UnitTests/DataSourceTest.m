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
//  DataSourceTest.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//

#import "DataSourceTest.h"
#import "DataConverter.h"

@implementation DataSourceTest

- (void)setUp {
    [super setUp];
    location = [[[CLLocationManager alloc] init] location];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateWikipediaDatasource {
    wikipedia = [[DataSource alloc] initTitle:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG" locked:NO];
    NSLog(@"Wikipedia JSONURL: %@", [wikipedia jsonUrl]);
    [wikipedia setActivated:YES];
    if ([wikipedia activated]) {
        NSLog(@"Wikipedia activated: YES");
    } else {
        NSLog(@"Wikipedia activated: NO");
    }
    STAssertNotNil(wikipedia, @"Could not create datasource object.");
}

- (void)testCreateTwitterDatasource {
    twitter = [[DataSource alloc] initTitle:@"Twitter" jsonUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm" locked:NO];
    [twitter setActivated:YES];
    STAssertNotNil(twitter, @"Could not create datasource object.");
}

- (void)testCreatePositionsFromDatasource {
    [self testCreateWikipediaDatasource];
    [self testCreateTwitterDatasource];
    [[DataConverter getInstance] convertData:wikipedia currentLocation:location currentRadius:3.5];
    [[DataConverter getInstance] convertData:twitter currentLocation:location currentRadius:3.5];
    BOOL test = true;
    if ([wikipedia.positions count] == 0) {
        test = false;
    }
    if ([twitter.positions count] == 0) {
        test = false;
    }
    NSLog(@"Wikipedia positions: %d", [wikipedia.positions count]);
    NSLog(@"Twitter positions: %d", [twitter.positions count]);
    STAssertTrue(test, @"Not all positions exists");
}

@end