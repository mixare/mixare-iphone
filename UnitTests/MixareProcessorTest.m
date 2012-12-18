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
//  MixareProcessorTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-12-12.
//

#import "MixareProcessorTest.h"

@implementation MixareProcessorTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateMixareProcessor {
    id<DataProcessor> processor = [[MixareProcessor alloc] init];
    STAssertNotNil(processor, @"Not created");
}

- (void)testConvertMixareData {
    id<DataProcessor> processor = [[MixareProcessor alloc] init];
    NSMutableArray* converted = [processor convert:@"{\"status\":\"OK\",\"num_results\":3,\"results\":[{\"id\":\"2827\",\"lat\":\"46.43893\",\"lng\":\"11.21706\",\"elevation\":\"1737\",\"title\":\"Penegal\",\"distance\":\"9.756\",\"webpage\":\"http%3A%2F%2Fwww.suedtirolerland.it%2Fapi%2Fmap%2FgetMarkerTplM%2F%3Fmarker_id%3D2827%26project_id%3D15%26lang_id%3D9\",\"marker\":\"http://url.com/marker.png\",\"logo\":\"http://url.com/image.png\"},{\"id\":\"2821\",\"lat\":\"46.49396\",\"lng\":\"11.2088\",\"elevation\":\"1865\",\"title\":\"Gantkofel\",\"distance\":\"9.771\",\"webpage\":\"\",\"marker\":\"http://url.com/marker.png\"},{\"id\":\"2829\",\"lat\":\"46.3591\",\"lng\":\"11.1921\",\"elevation\":\"2116\",\"title\":\"Roen\",\"distance\":\"17.545\",\"webpage\":\"http%3A%2F%2Fwww.suedtirolerland.it%2Fapi%2Fmap%2FgetMarkerTplM%2F%3Fmarker_id%3D2829%26project_id%3D15%26lang_id%3D9\",\"marker\":\"http://url.com/marker.png\"}]}"];
    NSString *title = [[NSString alloc] initWithString:[converted[0] valueForKey:@"title"]];
    NSLog(@"CONVERTED TITLE: %@", title);
    STAssertEqualObjects(title, @"Penegal", @"Convert failed");
}

@end
