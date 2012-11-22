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
//  WikipediaProcessor.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//

#import "WikipediaProcessor.h"

@implementation WikipediaProcessor

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)matchesDataType:(NSString*)title {
    if ([title isEqualToString:@"Wikipedia"]) {
        return YES;
    }
    return NO;
}

- (NSMutableArray*)convert:(NSString*)dataString {
    if (dataString != nil) {
        NSDictionary *data = [dataString JSONValue];
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        NSArray *geonames = data[@"geonames"];
        for (NSDictionary *geoname in geonames) {
            [ret addObject:@{
            keys[@"title"]: geoname[@"title"],
            keys[@"summary"]: geoname[@"summary"],
            keys[@"url"]: [NSString stringWithFormat:@"http://%@", geoname[@"wikipediaUrl"]],
            keys[@"longitude"]: geoname[@"lng"],
            keys[@"latitude"]: geoname[@"lat"],
            keys[@"marker"]: @"wikipedia_logo_small.png",
            keys[@"logo"]: @"wikipedia_logo.png"}];
        }
        return ret;
    }
	return nil;
}

/***
 *
 *  @OVERRIDE
 *  Initialize location data for URL
 *  Wikipedia API radius = max 20km
 *
 ***/
- (void)initUrlValues:(CLLocation*)loc radius:(float)rad {
    NSString *language = [NSLocale preferredLanguages][0];
    urlValueData[@"PARAM_LAT"] = [[NSString alloc] initWithFormat:@"%f", loc.coordinate.latitude];
    urlValueData[@"PARAM_LON"] = [[NSString alloc] initWithFormat:@"%f", loc.coordinate.longitude];
    urlValueData[@"PARAM_ALT"] = [[NSString alloc] initWithFormat:@"%f", loc.altitude];
    urlValueData[@"PARAM_LANG"] = language;
    if (rad > 20) {
        rad = 20;
    }
    urlValueData[@"PARAM_RAD"] = [[NSString alloc] initWithFormat:@"%f", rad];
}

@end
