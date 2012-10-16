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
//  DataConvertor.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DataConvertor.h"
#import "DataProcessor.h"
#import "TwitterProcessor.h"
#import "WikipediaProcessor.h"
#import "MixareProcessor.h"

static NSMutableArray* dataProcessors;
static NSMutableDictionary* urlValueData;
static DataConvertor* instance;

@implementation DataConvertor

+(DataConvertor*) ins {
    if (dataProcessors == nil) {
        dataProcessors = [NSMutableArray alloc];
        [self initDataProcessors];
    }
    if (instance == nil) {
        instance = [DataConvertor alloc];
    }
    if (urlValueData == nil) {
        urlValueData = [[NSMutableDictionary alloc] init];
    }
    return instance;
}

/***
 *
 *  Get available data processors
 *
 ***/
+(void) initDataProcessors {
    [dataProcessors addObject:[TwitterProcessor alloc]];
    [dataProcessors addObject:[WikipediaProcessor alloc]];
    [dataProcessors addObject:[MixareProcessor alloc]];
}

/***
 *
 *  PUBLIC: Get actual json-source url with current location
 *  AND convert json-source to useable Position objects IN the given DataSource object.
 *  @param DataSource
 *  @param CLLocation
 *
 ***/
+(void) convertData:(DataSource*)data currentLocation:(CLLocation*)loc {
    id <DataProcessor> processor = [self matchProcessor:data.title];
    [data refreshPositions:[processor convert:[[NSString alloc] initWithContentsOfURL:[self urlWithLocationFix:data.jsonUrl location:loc] encoding:NSUTF8StringEncoding error:nil]]];
}

/***
 *
 *  Get the right DataProcessor for the specific source
 *
 ***/
+(id) matchProcessor:(NSString*)title {
    id <DataProcessor> processor = nil;
    if ([title rangeOfString:@"Wikipedia"].location != NSNotFound) {
        processor = [[WikipediaProcessor alloc] init];
    } else if ([title rangeOfString:@"Twitter"].location != NSNotFound) {
        processor = [[TwitterProcessor alloc] init];
    } else {
        processor = [[MixareProcessor alloc] init];
    }
    return processor;
}

/***
 *
 *  Generate sourceURL with actual received location data
 *
 ***/
+(NSURL*) urlWithLocationFix:(NSString*)jsonUrl location:(CLLocation*)loc {
    [self initUrlValues:loc];
    NSString* stringURL = [[NSString alloc] initWithString:jsonUrl];
    for (NSString* key in urlValueData) {
        NSString* value = [urlValueData objectForKey:key];
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
+(void) initUrlValues:(CLLocation*)loc {
    float radius = 3.5;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",loc.coordinate.latitude] forKey:@"PARAM_LAT"];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",loc.coordinate.longitude] forKey:@"PARAM_LON"];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",loc.altitude] forKey:@"PARAM_ALT"];
    [urlValueData setObject:language forKey:@"PARAM_LANG"];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",radius] forKey:@"PARAM_RAD"];
}

/***
 *
 *  Parse URL with actual parameters (replaces the parameter names of the URL)
 *
 ***/
+(NSString*) url:(NSString*)url urlInfoFiller:(NSString*)target urlInfoReplacer:(NSString*)replacer {
    if ([url rangeOfString:target].location != NSNotFound) {
        url = [url stringByReplacingOccurrencesOfString:target withString:replacer];
    }
    return url;
}

@end
