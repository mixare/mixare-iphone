/* Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/> */

#import <Foundation/Foundation.h>
#define WIKI_BASE_URL @"http://ws.geonames.org/findNearbyWikipediaJSON"
#define TWITTER_BASE_URL  @"http://search.twitter.com/search.json"
#define BUZZ_BASE_URL @"https://www.googleapis.com/buzz/v1/activities/search?alt=json&max-results=20"
#define OSM_BASE_URL @"http://osmxapi.hypercube.telascience.org/api/0.6/node[railway=station]"
typedef enum  {WIKIPEDIA, BUZZ, TWITTER, OWNURL,OSM} DATASOURCE;

@interface DataSource : NSObject {
	

}
+(NSString *) createRequestURLFromDataSource: (NSString*) source Lat: (float) lat Lon: (float) lon Alt: (float) alt radius: (float) rad Lang: (NSString *) lang;
@end
