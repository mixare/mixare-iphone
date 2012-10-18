/* Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/> */
//
//  DataSource.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

@synthesize title, jsonUrl, activated, positions;

/***
 *
 *  CONSTRUCTOR
 *
 ***/
- (DataSource*)title:(NSString *)tit jsonUrl:(NSString *)url {
    self = [super init];
    if(self) {
        title = tit;
        jsonUrl = url;
        activated = YES;
        positions = [[NSMutableArray alloc] init];
    }
    return self;
}

/***
 *
 *  PUBLIC: (Re)create the position objects (for Markers and MapAnnotations views)
 *  (Called by DataConvertor)
 *
 ***/
- (void)refreshPositions:(NSMutableArray*)results {
    [positions removeAllObjects];
    for(NSDictionary *poi in results){
        CGFloat alt = [[poi valueForKey:@"alt"]floatValue];
        /*if (alt == 0.0) {
            alt = _locationManager.location.altitude+50;
        }*/
        Position* newPosition = [[Position alloc] initWithTitle:[poi valueForKey:@"title"] withSummary:[poi valueForKey:@"sum"] withUrl:[poi valueForKey:@"url"] withLatitude:[[poi valueForKey:@"lat"]floatValue] withLongitude:[[poi valueForKey:@"lon"]floatValue] withAltitude:alt];
        
        [positions addObject:newPosition];
    }
    NSLog(@"positions count: %d", [positions count]);
}
@end
