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
//  DownloadManagerTest.m
//  Mixare
//
//  Created by Aswin Ly on 23-10-12.
//

#import "DownloadManagerTest.h"

@implementation DownloadManagerTest

- (void)setUp {
    [super setUp];
    dataSourceManager = [[DataSourceManager alloc] init];
    locationManager = [[CLLocationManager alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDownloadData {
    DownloadManager *downloadManager = [[DownloadManager alloc] init];
    [downloadManager download:[dataSourceManager getActivatedSources] currentLocation:locationManager.location currentRadius:3.5];
    DataSource *data = [dataSourceManager getDataSourceByTitle:@"Wikipedia"];
    NSLog(@"Data positions after download: %d", data.positions.count);
    BOOL check;
    if (data.positions.count > 0) {
        check = YES;
    } else {
        check = NO;
    }
    STAssertTrue(check, @"Positions should be filled");
}

- (void)testAfterDownloadReadData {
    DownloadManager *downloadManager = [[DownloadManager alloc] init];
    [downloadManager download:[dataSourceManager getActivatedSources] currentLocation:locationManager.location currentRadius:3.5];
    for (DataSource *data in [dataSourceManager getActivatedSources]) {
        if ([data.title isEqualToString:@"Twitter"]) {
            data.activated = NO;
        }
    }
    [downloadManager download:[dataSourceManager getActivatedSources] currentLocation:locationManager.location currentRadius:3.5];
    [downloadManager download:[dataSourceManager getActivatedSources] currentLocation:locationManager.location currentRadius:3.5];
    for (DataSource *data in [dataSourceManager getActivatedSources]) {
        if ([data.title isEqualToString:@"Twitter"]) {
            data.activated = YES;
        }
    }
    [downloadManager download:[dataSourceManager getActivatedSources] currentLocation:locationManager.location currentRadius:3.5];
    [downloadManager download:[dataSourceManager getActivatedSources] currentLocation:locationManager.location currentRadius:3.5];
}

@end
