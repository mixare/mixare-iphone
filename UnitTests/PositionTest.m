//
//  PositionTest.m
//  Mixare
//
//  Created by Aswin Ly on 17-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "PositionTest.h"

@implementation PositionTest

- (void)setUp {
    [super setUp];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreatePosition {
    Position *pos = [[Position alloc] initWithTitle:@"Groothandels" withSummary:@"Mooi" withUrl:@"http://www.finalist.nl" withLatitude:40 withLongitude:20 withAltitude:3.4];
    STAssertNotNil(pos, @"Not created");
    STAssertEqualObjects(pos.title, @"Groothandels", @"Not the same title");
}

@end
