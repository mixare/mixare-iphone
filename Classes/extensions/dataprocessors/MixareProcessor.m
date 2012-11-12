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
//  MixareProcessor.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//

#import "MixareProcessor.h"

@implementation MixareProcessor

- (BOOL)matchesDataType:(NSString*)title {
    return YES;
}

- (NSMutableArray*)convert:(NSString*)dataString {
    if (![dataString isEqualToString:@""]) {
        NSDictionary* data = [dataString JSONValue];
        NSMutableArray* ret = [[NSMutableArray alloc] init];
        NSArray* geonames = data[@"results"];
        for(NSDictionary *geoname in geonames){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[keys[@"title"]] = geoname[@"title"];
            dic[keys[@"url"]] = geoname[@"webpage"];
            dic[keys[@"longitude"]] = geoname[@"lng"];
            dic[keys[@"latitude"]] = geoname[@"lat"];
            dic[keys[@"altitude"]] = geoname[@"elevation"];
            if (geoname[@"imagemarker"] != [NSNull null] && geoname[@"imagemarker"] != nil) {
                dic[keys[@"marker"]] = geoname[@"imagemarker"];
            }
            [ret addObject:dic];
        }
        return ret;
    } else return nil;
}

@end
