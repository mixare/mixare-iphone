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
//  DataSourceManagerTest.m
//  Mixare
//
//  Created by Aswin Ly on 17-10-12.
//

#import "DataSourceManagerTest.h"

@implementation DataSourceManagerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
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

- (void)testArrayCompare {
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    [array1 addObject:@"1"];
    [array1 addObject:@"0"];
    [array1 addObject:@"0"];
    [array2 addObject:@"1"];
    [array2 addObject:@"0"];
    [array2 addObject:@"0"];
    STAssertEqualObjects(array1, array2, @"Not the same");
}

- (void)testWriteAndDeleteDataSource {
    DataSourceManager *dataManager = [[DataSourceManager alloc] init];
    dataManager.dataSources = [[NSMutableArray alloc] init];
    DataSource *wikipedia = [dataManager createDataSource:@"Wikipedia" dataUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
    [dataManager createDataSource:@"Twitter" dataUrl:@"hhttp://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm"];
    NSArray *loadedData1 = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataSources"];
    NSLog(@"AMOUNT LOADED: %d", loadedData1.count);
    BOOL check = NO;
    if (loadedData1.count == 2) {
        check = YES;
    }
    STAssertTrue(check, @"Loading failed");
    check = NO;
    [dataManager deleteDataSource:wikipedia];
    NSArray *loadedData2 = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataSources"];
    NSLog(@"AMOUNT LOADED AFTER DELETE: %d", loadedData2.count);
    if (loadedData2.count == 1) {
        check = YES;
    }
    STAssertTrue(check, @"Loading failed");
}

- (void)testGetDataSourceFromTitle {
    DataSourceManager *dataManager = [[DataSourceManager alloc] init];
    dataManager.dataSources = [[NSMutableArray alloc] init];
    [dataManager createDataSource:@"Wikipedia" dataUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
    [dataManager createDataSource:@"Twitter" dataUrl:@"hhttp://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm"];
    STAssertEqualObjects([dataManager getDataSourceByTitle:@"Wikipedia"].jsonUrl, @"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG", @"Gets the wrong one");
}

@end
