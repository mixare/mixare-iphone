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
//  TwitterProcessor.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//

#import "TwitterProcessor.h"

@implementation TwitterProcessor

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSMutableArray*)convert:(NSString*)dataString {
    NSDictionary *data = [dataString JSONValue];
	NSMutableArray *ret = [[NSMutableArray alloc]init];
	NSArray *tweets = data[@"results"];
    float height = 8000.0;
	for (NSDictionary *tweet in tweets) {
        NSDictionary *geo = [self getGeoDictionary:tweet[@"geo"]];
        if ([self getLatitude:geo] != nil && [self getLongitude:geo] != nil) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[keys[@"user"]] = tweet[@"from_user"];
            dic[keys[@"user"]] = tweet[@"from_user"];
            dic[keys[@"summary"]] = tweet[@"from_user"];
            dic[keys[@"title"]] = tweet[@"text"];
            dic[keys[@"altitude"]] = [NSString stringWithFormat:@"%f", height];
            dic[keys[@"url"]] = [NSString stringWithFormat:@"http://twitter.com/%@", tweet[@"from_user"]];
            dic[keys[@"latitude"]] = [self getLatitude:geo];
            dic[keys[@"longitude"]] = [self getLongitude:geo];
            [ret addObject:dic];
        }
        //height += 1000;
	}
	return ret;
}

- (NSDictionary*)getGeoDictionary:(id)geoDic {
    if (geoDic != [NSNull null]) {
        return geoDic;
    }
    return nil;
}

- (NSString*)getLatitude:(NSDictionary*)geo {
    if (geo != nil) {
        NSArray *split = geo[@"coordinates"];
        return split[0];
    }
    return nil;
}

- (NSString*)getLongitude:(NSDictionary*)geo {
    if (geo != nil) {
        NSArray *split = geo[@"coordinates"];
        return split[1];
    }
    return nil;
}

@end
