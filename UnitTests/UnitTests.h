//
//  UnitTests.h
//  UnitTests
//
//  Created by Aswin Ly on 20-09-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataSource.h"

@interface UnitTests : SenTestCase {
    CLLocationManager* _locationManager;
}

@end
