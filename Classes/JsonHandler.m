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

#import "JsonHandler.h"
static NSString *kTitleKey = @"title";
static NSString *kLatKey = @"lat";
static NSString *kLonKey = @"lon";
static NSString *kAltKey = @"alt";
static NSString *kSummaryKey = @"sum";
static NSString *kUrlKey = @"url";
static NSString *kUserKey = @"user";
static NSString *kSourceKey = @"source";
static NSString *kReferenceKey = @"reference"; 

@implementation JsonHandler

-(NSMutableArray*)processWikipediaJSONData: (NSString*) jsonData{
	NSDictionary* data = [jsonData JSONValue];
	NSMutableArray* ret = [[NSMutableArray alloc]init];
	NSArray* geonames = [data objectForKey:@"geonames"];
	for(NSDictionary *geoname in geonames){
		//NSLog(@"Title: %@", [geoname objectForKey:@"title"]);
		//[ret addObject:[geoname objectForKey:@"title"]];
        
		[ret addObject:[NSDictionary dictionaryWithObjectsAndKeys:[geoname objectForKey:@"title"],kTitleKey, [geoname objectForKey:@"summary"],kSummaryKey,[NSString stringWithFormat:@"http://%@",[geoname objectForKey:@"wikipediaUrl"]],kUrlKey,[geoname objectForKey:@"lng"],kLonKey,[geoname objectForKey:@"lat"],kLatKey,[geoname objectForKey:@"elevation"],kAltKey, @"WIKIPEDIA",kSourceKey, nil]];
	}
	return ret;
}
-(NSMutableArray*)processMixareJSONData: (NSString*) jsonData{
    if(! [jsonData isEqualToString:@""]){
        NSDictionary* data = [jsonData JSONValue];
        NSMutableArray* ret = [[NSMutableArray alloc]init];
        NSArray* geonames = [data objectForKey:@"results"];
        for(NSDictionary *geoname in geonames){
            [ret addObject:[NSDictionary dictionaryWithObjectsAndKeys:[geoname objectForKey:@"title"],kTitleKey, [geoname objectForKey:@"webpage"],kUrlKey,[geoname objectForKey:@"lng"],kLonKey,[geoname objectForKey:@"lat"],kLatKey,[geoname objectForKey:@"elevation"],kAltKey,@"MIXARE",kSourceKey, nil]];
        }
        return ret;
    }else return nil;
}

-(NSMutableArray*)processTwitterJSONData: (NSString*) jsonData{
	NSDictionary * data = [jsonData JSONValue];
	NSMutableArray* ret = [[NSMutableArray alloc]init];
	NSArray* tweets = [data objectForKey:@"results"];
    float height = 8000.0;
	for(NSDictionary *tweet in tweets){
		[ret addObject:[NSDictionary dictionaryWithObjectsAndKeys:[tweet objectForKey:@"from_user"],kUserKey,[tweet objectForKey:@"text"],kTitleKey,[NSString stringWithFormat:@"http://twitter.com/%@",[tweet objectForKey:@"from_user"]],kUrlKey, @"TWITTER",kSourceKey,[NSString stringWithFormat:@"%f",height],kAltKey,nil]];
        height += 1000;
	}
	return ret;
}

-(NSMutableArray*)processGooglePlacesData: (NSString*) jsonData{
    NSDictionary* data = [jsonData JSONValue];
    NSMutableArray * ret = [[NSMutableArray alloc]init];
    NSArray * googlePlaces = [data objectForKey:@"results"];
    for(NSDictionary *place in googlePlaces){
        [ret addObject:[NSDictionary dictionaryWithObjectsAndKeys:[place objectForKey:@"name"],kTitleKey,[place objectForKey:@"reference"],kReferenceKey, nil]];
    }
    return ret;
}

-(NSMutableArray*)processBuzzJSONData: (NSString*) jsonData{
    if(jsonData != nil){
        NSDictionary * data = [jsonData JSONValue];
        NSMutableArray* ret = [[NSMutableArray alloc]init];
        NSDictionary* msgs = [data objectForKey:@"data"];
        NSArray* items = [msgs objectForKey:@"items"];
        float height = 8000.0;
        for(NSDictionary *msg in items){
            NSArray * splittedGeoCode = [[msg objectForKey:@"geocode"] componentsSeparatedByString:@" "];
            
            NSString* lat = [splittedGeoCode objectAtIndex:0];
            NSString* lng = [splittedGeoCode objectAtIndex:1];
            NSLog(@"%@:%@",lat,lng);
            NSDictionary * links = [msg objectForKey:@"links"];
            NSArray * alternate = [links objectForKey:@"alternate"];
            NSDictionary *href=[alternate objectAtIndex:0];
            NSString * link = [href objectForKey:@"href"];
            NSString * title = [msg objectForKey:@"title"];
            NSArray * words = [title componentsSeparatedByString:@" "];
            NSMutableString * finalText = [[NSMutableString alloc]init];
            for(int i=0;i <[words count]; i++){
                [finalText appendFormat:@" %@",[words objectAtIndex:i]];
                if(i % 3 ==0 && i !=0){
                    [finalText appendString: @"\n"];
                }
            }
            height += 1000;
            [ret addObject:[NSDictionary dictionaryWithObjectsAndKeys:lat,kLatKey,lng,kLonKey,title,kTitleKey, link,kUrlKey,@"BUZZ",kSourceKey,[NSString stringWithFormat:@"%f",height],kAltKey, nil]];
        }
        return ret;
    }return nil;
}
@end
