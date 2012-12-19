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
//  MapViewAnnotationTest.m
//  Mixare
//
//  Created by Aswin Ly on 19-12-12.
//

#import "MapViewAnnotationTest.h"

@implementation MapViewAnnotationTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateMapViewAnnotation {
    MapViewAnnotation *anno = [[MapViewAnnotation alloc] initWithLatitude:3.0 longitude:3.0];
    STAssertNotNil(anno, @"Annotation not created");
}

- (void)testAddingMapViewAnnotationData {
    MapViewAnnotation *anno = [[MapViewAnnotation alloc] initWithLatitude:2.0 longitude:2.0];
    [anno setTitle:@"COOL"];
    [anno setSubTitle:@"cool2"];
    [anno setUrl:@"http://url.com"];
    STAssertEquals(anno.title, @"COOL", @"Title not correct");
    STAssertEquals(anno.subTitle, @"cool2", @"subTitle not correct");
    STAssertEquals(anno.url, @"http://url.com", @"Url not correct");
}

- (void)testAddMapViewAnnotationMarker {
    MapViewAnnotation *anno = [[MapViewAnnotation alloc] initWithLatitude:2.0 longitude:2.0];
    UIImage *img = [[UIImage alloc] init];
    [anno setMarker:img];
    STAssertEqualObjects(anno.image, img, @"Image nog correct");
}

@end