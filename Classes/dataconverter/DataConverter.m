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
//  DataConverter.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//

#import "DataConverter.h"
#import "PluginLoader.h"
#import "DataProcessor.h"

static DataConverter *dataConverter;

@implementation DataConverter

+ (void)initialize {
    if (self == [DataConverter class]) {
        dataConverter = [[DataConverter alloc] init];
    }
}

+ (id)getInstance {
    return dataConverter;
}

- (id)init {
    self = [super init];
    if (self) {
        processors = [[PluginLoader getInstance] getPluginsFromClassName:@"DataProcessor"];
    }
    return self;
}

/***
 *
 *  PUBLIC: Get actual json-source url with current location
 *  AND convert json-source to useable Position objects IN the given DataSource object.
 *  @param DataSource
 *  @param CLLocation
 *  @param radius
 *
 ***/
- (void)convertData:(DataSource*)data currentLocation:(CLLocation*)loc currentRadius:(float)rad {
    id<DataProcessor> processor = [self matchProcessor:data.title];
    [data refreshPositions:[processor convert:[processor createDataString:data.jsonUrl location:loc radius:rad]]];
}

/***
 *
 *  Get the right DataProcessor for the specific source
 *
 ***/
- (id)matchProcessor:(NSString*)title {
    for (id<DataProcessor> processor in processors) {
        if ([processor matchesDataType:title]) {
            return processor;
        }
    }
    return nil;
}

@end
