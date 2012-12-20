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
//  DownloadManager.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//

#import "DownloadManager.h"
#import "DataConverter.h"

@implementation DownloadManager

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)radiusChanged:(float)rad {
    if (rad != lastDownloadedRadius) {
        return YES;
    }
    return NO;
}

- (BOOL)dataInputChanged:(NSMutableArray*)datas {
    if (![datas isEqual:lastDownloadedSources]) {
        return YES;
    }
    return NO;
}

- (void)download:(NSMutableArray*)datas currentLocation:(CLLocation*)loc currentRadius:(float)rad {
    if ([self dataInputChanged:datas] || [self radiusChanged:rad]) {
        NSMutableArray *downloadArray = [[NSMutableArray alloc] initWithArray:datas];
        if ([self dataInputChanged:datas]) {
            [downloadArray removeObjectsInArray:lastDownloadedSources];
        }
        for (DataSource *data in downloadArray) {
            [[DataConverter getInstance] convertData:data currentLocation:loc currentRadius:rad];
        }
        lastDownloadedLocation = loc;
        lastDownloadedRadius = rad;
        [lastDownloadedSources removeAllObjects];
        lastDownloadedSources = datas;
    }
}

- (void)redownload {
    for (DataSource *data in lastDownloadedSources) {
        [[DataConverter getInstance] convertData:data currentLocation:lastDownloadedLocation currentRadius:lastDownloadedRadius];
    }
}

@end
