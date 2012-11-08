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
//  DataSourceManager.m
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//

#import "DataSourceManager.h"

@implementation DataSourceManager

@synthesize dataSources;

- (DataSourceManager*)init {
    self = [super init];
    [self loadDataSources]; // run app without this method to clean the local storage
    [self initDataSources];
    return self;
}

- (DataSourceManager*)initWithoutLocalData {
    self = [super init];
    [self initDataSources];
    return self;
}

- (void)initDataSources {
    if (dataSources.count == 0 || dataSources == nil) {
        NSLog(@"First create DataSources");
        dataSources = [NSMutableArray array];
        DataSource *wikipedia = [[DataSource alloc] initTitle:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
        DataSource *twitter = [[DataSource alloc] initTitle:@"Twitter" jsonUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm"];
        DataSource *google = [[DataSource alloc] initTitle:@"Google Addresses" jsonUrl:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=PARAM_LAT,PARAM_LON&sensor=true"];
        wikipedia.locked = YES;
        twitter.locked = YES;
        google.locked = YES;
        [dataSources addObject:wikipedia];
        [dataSources addObject:twitter];
        [dataSources addObject:google];
        [self writeDataSources];
    }
}

- (DataSource*)getDataSourceByTitle:(NSString*)title {
    for (DataSource *data in dataSources) {
        if ([data.title isEqualToString:title]) {
            return data;
        }
    }
    return nil;
}

- (NSMutableArray*)getActivatedSources {
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (DataSource *source in dataSources) {
        if (source.activated) {
            [sources addObject:source];
        }
    }
    return sources;
}

- (DataSource*)createDataSource:(NSString *)title dataUrl:(NSString *)url {
    if ([self getDataSourceByTitle:title] == nil) {
        DataSource *data = [[DataSource alloc] initTitle:title jsonUrl:url];
        data.activated = NO;
        [dataSources addObject:data];
        [self writeDataSources];
        return data;
    } 
    return nil;
}

- (void)writeDataSources {
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    for (DataSource *data in dataSources) {
        [saveArray addObject:@{@"title":data.title, @"url":data.jsonUrl, @"locked":[self boolToString:data.locked]}];
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"dataSources"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadDataSources {
    NSArray *loadedData = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataSources"];
    dataSources = [NSMutableArray array];
    for (NSDictionary *data in loadedData) {
        DataSource *source = [[DataSource alloc] initTitle:data[@"title"] jsonUrl:data[@"url"]];
        if ([data[@"locked"] isEqualToString:@"YES"]) {
            source.locked = YES;
        } else {
            source.locked = NO;
        }
        [dataSources addObject:source];
    }
}

- (void)deleteDataSource:(DataSource*)source {
    [dataSources removeObject:source];
    [self writeDataSources];
}

- (NSString*)boolToString:(BOOL)boolean {
    if (boolean) {
        return @"YES";
    } else {
        return @"NO";
    }
}

@end
