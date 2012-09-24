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

#import "UnitTests.h"

@implementation UnitTests

- (void)setUp {
    [super setUp];
    _locationManager = [[CLLocationManager alloc] init];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreateWikipediaDatasource {
    wikipedia = [[DataSource alloc] initWithLocationManager:_locationManager title:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
    NSLog(@"Wikipedia JSONURL: %@", [wikipedia jsonUrl]);
    if ([wikipedia activated]) {
        NSLog(@"Wikipedia activated: YES");
    } else {
        NSLog(@"Wikipedia activated: NO");
    }
    STAssertNotNil(wikipedia, @"Could not create datasource object.");
}

- (void)testCreateTwitterDatasource {
    twitter = [[DataSource alloc] initWithLocationManager:_locationManager title:@"Twitter" jsonUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm"];
    STAssertNotNil(twitter, @"Could not create datasource object.");
}

- (void)testCreatePositionsFromDatasource {
    [self testCreateWikipediaDatasource];
    [self testCreateTwitterDatasource];
    [wikipedia refreshPositions];
    [twitter refreshPositions];
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
