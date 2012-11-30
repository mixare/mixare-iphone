//
//  ArenaProcessor.m
//  Mixare
//
//  Created by Aswin Ly on 21-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
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
             keys[@"marker"]: geoname[@"object_url"]}];
        }
        return ret;
    }
    return nil;
}

@end
