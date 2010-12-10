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
