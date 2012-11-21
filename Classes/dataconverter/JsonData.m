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
//  JsonData.m
//  Mixare
//
//  Created by Aswin Ly on 16-10-12.
//

#import "JsonData.h"

@implementation JsonData

- (id)init {
    self = [super init];
    keys = @{@"title": @"title",
    @"latitude": @"lat",
    @"longitude": @"lon",
    @"altitude": @"alt",
    @"summary": @"sum",
    @"url": @"url",
    @"user": @"user",
    @"source": @"source",
    @"marker": @"imagemarker",
    @"reference": @"reference",
    @"logo": @"logo"};
    urlValueData = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSString*)createDataString:(NSString*)jsonUrl location:(CLLocation*)loc radius:(float)rad {
    return [NSString stringWithContentsOfURL:[self urlWithLocationFix:jsonUrl location:loc radius:rad] encoding:NSUTF8StringEncoding error:nil];
}

/***
 *
 *  Generate sourceURL with actual received location data
 *
 ***/
- (NSURL*)urlWithLocationFix:(NSString*)jsonUrl location:(CLLocation*)loc radius:(float)rad {
    [self initUrlValues:loc radius:rad];
    NSString *stringURL = [[NSString alloc] initWithString:jsonUrl];
    for (NSString *key in urlValueData) {
        NSString *value = urlValueData[key];
        stringURL = [self url:stringURL urlInfoFiller:key urlInfoReplacer:value];
    }
    NSLog(@"GENERATED DATA URL: %@", stringURL);
    NSURL *url = [NSURL URLWithString:stringURL];
    return url;
}

/***
 *
 *  Initialize location data for URL
 *
 ***/
- (void)initUrlValues:(CLLocation*)loc radius:(float)rad {
    NSString *language = [NSLocale preferredLanguages][0];
    urlValueData[@"PARAM_LAT"] = [[NSString alloc] initWithFormat:@"%f", loc.coordinate.latitude];
    urlValueData[@"PARAM_LON"] = [[NSString alloc] initWithFormat:@"%f", loc.coordinate.longitude];
    urlValueData[@"PARAM_ALT"] = [[NSString alloc] initWithFormat:@"%f", loc.altitude];
    urlValueData[@"PARAM_LANG"] = language;
    urlValueData[@"PARAM_RAD"] = [[NSString alloc] initWithFormat:@"%f", rad];
}

/***
 *
 *  Parse URL with actual parameters (replaces the parameter names of the URL)
 *
 ***/
- (NSString*)url:(NSString*)url urlInfoFiller:(NSString*)target urlInfoReplacer:(NSString*)replacer {
    if ([url rangeOfString:target].location != NSNotFound) {
        url = [url stringByReplacingOccurrencesOfString:target withString:replacer];
    }
    return url;
}

@end
