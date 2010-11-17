//
//  DataSource.h
//  Mixare
//
//  Created by jakob on 15.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

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
