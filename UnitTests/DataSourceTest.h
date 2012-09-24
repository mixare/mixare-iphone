//
//  DataSourceTest.h
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataSource.h"

@interface DataSourceTest : SenTestCase {
    CLLocationManager* _locationManager;
    DataSource* wikipedia;
    DataSource* twitter;
}

@end
