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
    [super init];
    [self initDataSources];
    return self;
}

- (void)initDataSources {
    dataSources = [self loadDataSources];
    if (dataSources.count == 0 || dataSources == nil) {
        NSLog(@"First create DataSources");
        dataSources = [[NSMutableArray alloc] init];
        DataSource *wikipedia = [[DataSource alloc] title:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
        DataSource *twitter = [[DataSource alloc] title:@"Twitter" jsonUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm"];
        [dataSources addObject:wikipedia];
        [dataSources addObject:twitter];
        [self writeDataSources];
    }
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

- (void)writeDataSources {
    NSMutableArray *saveArray = [[[NSMutableArray alloc] init] autorelease];
    for (DataSource *data in dataSources) {
        [saveArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:data.title, @"title", data.jsonUrl, @"url", nil]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"dataSources"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray*)loadDataSources {
    NSArray *loadedData = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataSources"];
    NSMutableArray *convertedData = [[NSMutableArray alloc] init];
    for (NSDictionary *data in loadedData) {
        DataSource *source = [[DataSource alloc] title:[data objectForKey:@"title"] jsonUrl:[data objectForKey:@"url"]];
        [convertedData addObject:source];
    }
    return convertedData;
}

- (void)deleteDataSource:(DataSource*)source {
    [dataSources removeObject:source];
    [self writeDataSources];
}

- (void)dealloc {
    [super dealloc];
    [dataSources release];
}

@end
