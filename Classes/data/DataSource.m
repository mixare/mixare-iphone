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
//  DataSource.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//

#import "DataSource.h"

@implementation DataSource

@synthesize title, jsonUrl, activated, locked, positions;

/***
 *
 *  CONSTRUCTOR
 *
 ***/
- (DataSource*)initTitle:(NSString*)tit jsonUrl:(NSString*)url {
    self = [super init];
    if(self) {
        title = tit;
        jsonUrl = url;
        activated = YES;
        locked = NO;
        positions = [[NSMutableArray alloc] init];
    }
    return self;
}

/***
 *
 *  PUBLIC: (Re)create the position objects (for PoiItem and MapAnnotations views)
 *  (Called by DataConvertor)
 *
 ***/
- (void)refreshPositions:(NSMutableArray*)results {
    [positions removeAllObjects];
    positions = [[NSMutableArray alloc] init];
    for (NSDictionary *poi in results) {
        CGFloat alt = [[poi valueForKey:@"alt"] floatValue];
        float lat = [[poi valueForKey:@"lat"] floatValue];
        float lon = [[poi valueForKey:@"lon"] floatValue];
        Position *newPosition = [[Position alloc] initWithTitle:[poi valueForKey:@"title"] withSummary:[poi valueForKey:@"sum"] withUrl:[poi valueForKey:@"url"] withLatitude:lat withLongitude:lon withAltitude:alt withSource:title];
        if (poi[@"imagemarker"] != nil) {
            [newPosition setMarker:poi[@"imagemarker"]];
        }
        [positions addObject:newPosition];
    }
    NSLog(@"positions count: %d", [positions count]);
}

@end
