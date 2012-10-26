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

- (NSMutableArray*)convert:(NSString*)dataString {
    NSDictionary *data = [dataString JSONValue];
	NSMutableArray *ret = [[NSMutableArray alloc] init];
	NSArray *geonames = data[@"geonames"];
	for (NSDictionary *geoname in geonames) {
		[ret addObject:@{
         keys[@"title"]: geoname[@"title"],
         keys[@"summary"]: geoname[@"summary"],
         keys[@"url"]: [NSString stringWithFormat:@"http://%@", geoname[@"wikipediaUrl"]],
         keys[@"longitude"]: geoname[@"lng"],
         keys[@"latitude"]: geoname[@"lat"]}];
	}
	return ret;
}

@end
