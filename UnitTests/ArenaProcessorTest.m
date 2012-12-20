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
//  ArenaProcessorTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-12-12.
//

#import "ArenaProcessorTest.h"

@implementation ArenaProcessorTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateArenaProcessor {
    id<DataProcessor> processor = [[ArenaProcessor alloc] init];
    STAssertNotNil(processor, @"Not created");
}

- (void)testConvertArenaData {
    id<DataProcessor> processor = [[ArenaProcessor alloc] init];
    NSMutableArray* converted = [processor convert:@"{\"stats\":\"OK\",\"num_results\":2,\"results\":[{\"id\":14,\"lat\":51.930195,\"lng\":4.478632,\"elevation\":0,\"title\":\"LOL\",\"radius\":0.0,\"has_detail_page\":1,\"webpage\":\"http://ad-arena.finalist.com/arena-server/item/show/12/14/zwart.item\",\"object_type\":\"question\",\"object_url\":\"http://ad-arena.finalist.com/arena-server/images/green-question.png\"},{\"id\":16,\"lat\":51.94893,\"lng\":4.464387,\"elevation\":0,\"title\":\"VerhaaZZZ\",\"radius\":0.0,\"has_detail_page\":1,\"webpage\":\"http://ad-arena.finalist.com/arena-server/item/show/16.item\",\"object_type\":\"information\",\"object_url\":\"http://ad-arena.finalist.com/arena-server/images/information.png\"}]}"];
    NSString *title = [[NSString alloc] initWithString:[converted[0] valueForKey:@"title"]];
    NSLog(@"CONVERTED TITLE: %@", title);
    STAssertEqualObjects(title, @"LOL", @"Convert failed");
}

@end
