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
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DownloadManager.h"
#import "DataConvertor.h"

@implementation DownloadManager

- (DownloadManager*)init {
    [super init];
    return self;
}

- (BOOL)dataInputChanged:(NSMutableArray*)datas currentRadius:(float)rad {
    if (![datas isEqual:lastDownloadedSources] || rad != lastDownloadedRadius) {
        return YES;
    }
    return NO;
}

- (void)download:(NSMutableArray*)datas currentLocation:(CLLocation*)loc currentRadius:(float)rad {
    if ([self dataInputChanged:datas currentRadius:rad]) {
        [lastDownloadedSources removeAllObjects];
        for (DataSource* data in datas) {
            [DataConvertor convertData:data currentLocation:loc currentRadius:rad];
        }
        lastDownloadedSources = datas;
        lastDownloadedRadius = rad;
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
