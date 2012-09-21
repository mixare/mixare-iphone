//
//  UnitTests.m
//  UnitTests
//
//  Created by Aswin Ly on 20-09-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "UnitTests.h"

@implementation UnitTests

- (void)setUp
{
    [super setUp];
    _locationManager = [[CLLocationManager alloc] init];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    DataSource* wikipedia = [[DataSource alloc] initWithLocationManager:_locationManager title:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
    [wikipedia refreshPositions];
    STFail(@"Unit tests are not implemented yet in UnitTests");
}

@end
