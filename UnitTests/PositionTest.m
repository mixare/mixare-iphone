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
//  PositionTest.m
//  Mixare
//
//  Created by Aswin Ly on 17-10-12.
//

#import "PositionTest.h"

@implementation PositionTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatePosition {
    Position *pos = [[Position alloc] initWithTitle:@"Groothandels" withSummary:@"Mooi" withUrl:@"http://www.finalist.nl" withLatitude:40 withLongitude:20 withAltitude:3.4 withSource:nil];
    STAssertNotNil(pos, @"Not created");
    STAssertEqualObjects(pos.title, @"Groothandels", @"Not the same title");
}

- (void)testCreatedMarkers {
    Position *pos = [[Position alloc] initWithTitle:@"Groothandels" withSummary:@"Mooi" withUrl:@"http://www.finalist.nl" withLatitude:40 withLongitude:20 withAltitude:3.4 withSource:nil];
    STAssertNotNil(pos.poiItem, @"Poi Item not created");
    STAssertNotNil(pos.mapViewAnnotation, @"MapViewAnnotation not created");
}

@end
