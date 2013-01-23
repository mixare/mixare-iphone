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
#import "DataSourceList.h"

@implementation DataSourceManager

@synthesize dataSources;

- (id)init {
    self = [super init];
    [self loadDataSources];
    return self;
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
        DataSource *data = [[DataSource alloc] initTitle:title jsonUrl:url locked:NO];
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
        if (!data.locked) {
            [saveArray addObject:@{@"title":data.title, @"url":data.jsonUrl}];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"dataSources"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadDataSources {
    NSArray *loadedData = [[NSUserDefaults standardUserDefaults] arrayForKey:@"dataSources"];
    dataSources = [NSMutableArray array];
    for (DataSource *data in [[DataSourceList getInstance] dataSources]) {
        [dataSources addObject:data];
    }
    for (NSDictionary *data in loadedData) {
        DataSource *source = [[DataSource alloc] initTitle:data[@"title"] jsonUrl:data[@"url"] locked:NO];
        [dataSources addObject:source];
    }
}

- (void)deleteDataSource:(DataSource*)source {
    if (!source.locked) {
        [dataSources removeObject:source];
    }
    [self writeDataSources];
}

- (void)deactivateAllSources {
    for (DataSource *data in dataSources) {
        data.activated = NO;
    }
}

- (void)clearLocalData {
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"dataSources"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
