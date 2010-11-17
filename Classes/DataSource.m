//
//  DataSource.m
//  Mixare
//
//  Created by jakob on 15.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"


@implementation DataSource
+(NSString *) createRequestURLFromDataSource: (NSString*) source Lat: (float) lat Lon: (float) lon Alt: (float) alt radius: (float) rad Lang: (NSString *) lang{
	NSString * ret;
	if([source isEqualToString: @"WIKIPEDIA"] ){
		ret = [NSString stringWithFormat:@"%@?lat=%f&lng=%f&radius=%f&maxRows=50&lang=%@",WIKI_BASE_URL,lat,lon,rad,lang];
	}else if ([source isEqualToString: @"BUZZ"]){
		ret = [NSString stringWithFormat:@"%@&lat=%f&lon=%f&radius=%f",BUZZ_BASE_URL,lat,lon,rad*1000];		
	}else if ([source isEqualToString: @"TWITTER"]){
		ret = [NSString stringWithFormat:@"%@?geocode=%f,%f,%fkm",TWITTER_BASE_URL,lat,lon,rad];
		return ret;
	}else if ([source isEqualToString: @"OSM"]){
		//ret=@"";
	}else if ([source isEqualToString: @"OWNURL"]){
		
	}
	return ret;
}
@end
