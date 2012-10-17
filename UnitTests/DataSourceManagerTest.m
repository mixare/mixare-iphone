//
//  DataSourceManagerTest.m
//  Mixare
//
//  Created by Aswin Ly on 17-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DataSourceManagerTest.h"

@implementation DataSourceManagerTest

- (void)setUp {
    [super setUp];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreateDataSourceManager {
    DataSourceManager *dataManager = [[DataSourceManager alloc] init];
    STAssertNotNil(dataManager, @"Not created");
}

- (void)testInitializedData {
    DataSourceManager *dataManager = [[DataSourceManager alloc] init];
    for (DataSource *data in dataManager.dataSources) {
        NSLog(@"INITIALIZED TITLE: %@", data.title);
    }
    STAssertNotNil(dataManager.dataSources, @"Not initialized");
}

- (void)testActivatedData {
    DataSourceManager *dataManager = [[DataSourceManager alloc] init];
    if (dataManager.getActivatedSources != nil) {
        for (DataSource *data in dataManager.getActivatedSources) {
            STAssertTrue(data.activated, @"NOT ACTIVATED");
        }
    }
}

@end
