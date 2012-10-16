//
//  DataConvertorTest.m
//  Mixare
//
//  Created by Aswin Ly on 16-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DataConvertorTest.h"


@implementation DataConvertorTest

- (void)setUp {
    [super setUp];
    // Set-up code here.
    [DataConvertor ins];
    wikipedia = [[DataSource alloc] title:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
    [wikipedia setActivated:YES];
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testConvertData {
    CLLocation *location = [[[CLLocationManager alloc] init] location];
    [DataConvertor convertData:wikipedia currentLocation:location];
}

@end
