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
//  PoiItemTest.m
//  Mixare
//
//  Created by Aswin Ly on 19-12-12.
//

#import "PoiItemTest.h"
#import "Position.h"
#import "DataSource.h"
#import <CoreLocation/CoreLocation.h>

@implementation PoiItemTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatePoiItem {
    PoiItem *poi = [[PoiItem alloc] initCoordinateWithRadialDistance:2.0 inclination:3.0 azimuth:1.0];
    STAssertNotNil(poi, @"POI 1 not created");
    PoiItem *poi2 = [[PoiItem alloc] initWithLatitude:3.0 longitude:1.0 altitude:2.0 position:[[Position alloc] initWithTitle:@"hi" withSummary:@"hi" withUrl:@"http://url" withLatitude:2.0 withLongitude:1.0 withAltitude:4.0 withSource:[[DataSource alloc] initTitle:@"wikipedia" jsonUrl:@"http://url.com" locked:NO]]];
    STAssertNotNil(poi2, @"POI 2 not created");
}

- (void)testCalibrateUsingOrigin {
    PoiItem *poi = [[PoiItem alloc] initWithLatitude:3.0 longitude:1.0 altitude:2.0 position:[[Position alloc] initWithTitle:@"hi" withSummary:@"hi" withUrl:@"http://url" withLatitude:2.0 withLongitude:1.0 withAltitude:4.0 withSource:[[DataSource alloc] initTitle:@"wikipedia" jsonUrl:@"http://url.com" locked:NO]]];
    [poi calibrateUsingOrigin:[[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(2.0, 2.4) altitude:1.0 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil]];
}

@end
