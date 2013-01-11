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
//  ArenaProcessor.m
//  Mixare
//
//  Created by Aswin Ly on 21-11-12.
//

#import "ArenaProcessor.h"

@implementation ArenaProcessor

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)matchesDataType:(NSString*)title {
    if ([title isEqualToString:@"Arena"]) {
        return YES;
    }
    return NO;
}

/***
 *
 *  OVERRIDE STRING-CREATOR
 *
 ***/
- (NSString*)createDataString:(NSString*)jsonUrl location:(CLLocation*)loc radius:(float)rad {
    return [NSString stringWithContentsOfURL:[self urlWithLocationFix:jsonUrl location:loc radius:rad] encoding:NSUTF8StringEncoding error:nil];
}

- (NSURL*)urlWithLocationFix:(NSString*)jsonUrl location:(CLLocation*)loc radius:(float)rad {
    NSString *stringURL = [NSString stringWithFormat:@"%@&lat=%f&lng=%f", jsonUrl, loc.coordinate.latitude, loc.coordinate.longitude];
    NSLog(@"GENERATED DATA URL: %@", stringURL);
    NSURL *url = [NSURL URLWithString:stringURL];
    return url;
}

- (NSMutableArray*)convert:(NSString*)dataString {
    if (dataString != nil) {
        NSDictionary *data = [dataString JSONValue];
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        NSArray *geonames = data[@"results"];
        for (NSDictionary *geoname in geonames) {
            NSString *url = @"";
            if (geoname[@"webpage"] != [NSNull null] && geoname[@"webpage"] != nil) {
                url = geoname[@"webpage"];
            }
            [ret addObject:@{
             keys[@"title"]: geoname[@"title"],
             keys[@"summary"]: geoname[@"object_type"],
             keys[@"url"]: url,
             keys[@"longitude"]: geoname[@"lng"],
             keys[@"latitude"]: geoname[@"lat"],
             keys[@"marker"]: geoname[@"object_url"],
             keys[@"logo"]: @"arena_logo.png"}];
        }
        return ret;
    }
    return nil;
}

@end
