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

@synthesize title, jsonUrl, activated, locked, positions, logo;

/***
 *
 *  CONSTRUCTOR
 *
 ***/
- (id)initTitle:(NSString*)tit jsonUrl:(NSString*)url locked:(BOOL)lock {
    self = [super init];
    if(self) {
        title = tit;
        jsonUrl = url;
        activated = YES;
        locked = lock;
        positions = [[NSMutableArray alloc] init];
    }
    return self;
}

/***
 *
 *  PUBLIC: (Re)create the position objects (for PoiItem and MapAnnotations views)
 *  (Called by DataConverter)
 *
 ***/
- (void)refreshPositions:(NSMutableArray*)results {
    [positions removeAllObjects];
    if (results.count > 0) {
        if ([results[0] valueForKey:@"logo"] != nil && logo == nil) {
            [self setListLogo:[results[0] valueForKey:@"logo"]];
        }
    }
    positions = [[NSMutableArray alloc] init];
    for (NSDictionary *poi in results) {
        CGFloat alt = [[poi valueForKey:@"alt"] floatValue];
        float lat = [[poi valueForKey:@"lat"] floatValue];
        float lon = [[poi valueForKey:@"lon"] floatValue];
        Position *newPosition = [[Position alloc] initWithTitle:[poi valueForKey:@"title"] withSummary:[poi valueForKey:@"sum"] withUrl:[poi valueForKey:@"url"] withLatitude:lat withLongitude:lon withAltitude:alt withSource:self];
        if (poi[@"imagemarker"] != nil) {
            [newPosition setMarker:poi[@"imagemarker"]];
        }
        [positions addObject:newPosition];
    }
    NSLog(@"positions count: %d", [positions count]);
}

- (void)setListLogo:(NSString*)marker {
    if ([self isImageUrl:marker]) {
        NSURL *urls = [NSURL URLWithString:marker];
        NSData *data = [NSData dataWithContentsOfURL:urls];
        logo = [UIImage imageWithData:data];
    } else if (marker != nil) {
        logo = [UIImage imageNamed:marker];
        if (logo == nil) {
            logo = [UIImage imageWithContentsOfFile:marker];
        }
    }
}

- (BOOL)isImageUrl:(NSString*)urls {
    NSArray *elements = @[@"http", @"."];
    for (NSString *element in elements) {
        if ([urls rangeOfString:element].location == NSNotFound) {
            return NO;
        }
    }
    NSArray *possibleFiles = @[@"jpeg", @"png", @"jpg"];
    for (NSString *file in possibleFiles) {
        if ([urls rangeOfString:file].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

@end
