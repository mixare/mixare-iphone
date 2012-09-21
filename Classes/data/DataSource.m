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

@synthesize title, jsonUrl, activated;

/***
 *
 *  CONSTRUCTOR
 *
 ***/
-(DataSource*) initWithLocationManager:(CLLocationManager *)loc title:(NSString *)tit jsonUrl:(NSString *)url {
    self = [super init];
    if(self) {
        _locationManager = loc;
        title = tit;
        jsonUrl = url;
        activated = NO;
        jHandler = [[JsonHandler alloc] init];
        positions = [[NSMutableArray alloc] init];
        [self initUrlValues];
    }
    return self;
}

/***
 *
 *  Lock standard data values in class
 *  Initialize the standard parameter names of the json URL
 *
 ***/
-(void) initUrlValues {
    float radius = 3.5;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    urlValueData = [NSMutableDictionary alloc];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",_locationManager.location.coordinate.latitude] forKey:@"PARAM_LAT"];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",_locationManager.location.coordinate.longitude] forKey:@"PARAM_LON"];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",_locationManager.location.altitude] forKey:@"PARAM_ALT"];
    [urlValueData setObject:language forKey:@"PARAM_LANG"];
    [urlValueData setObject:[[NSString alloc] initWithFormat:@"%f",radius] forKey:@"PARAM_RAD"];
}

/***
 *
 *  PUBLIC: (Re)create the position objects (for Markers and MapAnnotations views)
 *
 ***/
-(void) refreshPositions {
    [positions removeAllObjects];
    for(NSDictionary *poi in [self getJsonData]){
        CGFloat alt = [[poi valueForKey:@"alt"]floatValue];
        if (alt == 0.0) {
            alt = _locationManager.location.altitude+50;
        }
        Positions* newPosition = [[Positions alloc] initWithTitle:[poi valueForKey:@"title"] initWithSummary:[poi valueForKey:@"sum"] withUrl:[poi valueForKey:@"url"] withLatitude:[[poi valueForKey:@"lat"]floatValue] withLongitude:[[poi valueForKey:@"lon"]floatValue] withAltitude:alt];
        
        [positions addObject:newPosition];
    }
    NSLog(@"positions count: %d", [positions count]);
}

/***
 *
 *  Get JSON data in dictionary from actual URL
 *
 ***/
-(NSMutableArray*) getJsonData {
    NSMutableArray* ret = [[NSMutableArray alloc]init];
    if ([self.title rangeOfString:@"Wikipedia"].location != NSNotFound) {
        ret = [jHandler processWikipediaJSONData:[[NSString alloc] initWithContentsOfURL:[self createActualSourceURL] encoding:NSUTF8StringEncoding error:nil]];
    } else if ([self.title rangeOfString:@"Twitter"].location != NSNotFound) {
        ret = [jHandler processTwitterJSONData:[[NSString alloc] initWithContentsOfURL:[self createActualSourceURL] encoding:NSUTF8StringEncoding error:nil]];
    }
    return ret;
}

/***
 *
 *  Generate sourceURL with actual received location data
 *
 ***/
-(NSURL*) createActualSourceURL {
    NSString* stringURL = [[NSString alloc] initWithString:jsonUrl];
    for (NSString* key in urlValueData) {
        NSString* value = [urlValueData objectForKey:key];
        stringURL = [self url:stringURL urlInfoFiller:key urlInfoReplacer:value];
    }
    NSURL *url = [NSURL URLWithString:stringURL];
    return url;
}

/***
 *
 *  Parse URL with actual parameters (replaces the parameter names of the URL)
 *
 ***/
-(NSString*) url:(NSString*)url urlInfoFiller:(NSString*)target urlInfoReplacer:(NSString*)replacer {
    if ([url rangeOfString:target].location != NSNotFound) {
        url = [url stringByReplacingOccurrencesOfString:target withString:replacer];
    }
    return url;
}
@end
