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
//  GoogleAddressesProcessor.m
//  Mixare
//
//  Created by Aswin Ly on 31-10-12.
//

#import "GoogleAddressesProcessor.h"

@implementation GoogleAddressesProcessor

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)matchesDataType:(NSString*)title {
    if ([title isEqualToString:@"Google Addresses"]) {
        return YES;
    }
    return NO;
}

- (NSMutableArray*)convert:(NSString*)dataString {
    if (dataString != nil) {
        NSDictionary *data = [dataString JSONValue];
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        NSArray *results = data[@"results"];
        for (NSDictionary *component in results) {
            [ret addObject:@{
             keys[@"title"]: component[@"formatted_address"],
             keys[@"url"]: [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@,%@", component[@"geometry"][@"location"][@"lat"], component[@"geometry"][@"location"][@"lng"]],
             keys[@"longitude"]: component[@"geometry"][@"location"][@"lng"],
             keys[@"latitude"]: component[@"geometry"][@"location"][@"lat"],
             keys[@"marker"]: @"buzz_logo_small.png",
             keys[@"logo"]: @"buzz_logo.png"}];
        }
        return ret;
    }
	return nil;
}

@end