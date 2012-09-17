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
#import "DataHandler.h"
#import "DataSource.h"
#import "JsonHandler.h"


@implementation DataHandler

@synthesize _dataArray;

-(id) initWithLocationManager:(CLLocationManager *)loc initRadius:(float)rad {
    self = [super init];
    if (self) {
        json = [[JsonHandler alloc] init];
        locManager = loc;
        pos = loc.location;
        radius = rad;
        language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    return self;
}

-(NSString *) getData:(NSString *)sourceName {
    NSString *source = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:sourceName Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:pos.altitude radius:radius Lang:language]] encoding:NSUTF8StringEncoding error:nil];
    return source;
}

-(NSMutableArray *) retrieveAvailableSources {
    [_dataArray removeAllObjects];
    _dataArray = [json processTwitterJSONData:[self getData:@"TWITTER"]];
    [_dataArray addObjectsFromArray:[json processWikipediaJSONData:[self getData:@"WIKIPEDIA"]]];
    return _dataArray;
}

-(void) dealloc {
    [super dealloc];
    [json release];
}

@end