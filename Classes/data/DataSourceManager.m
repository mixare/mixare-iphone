//
//  DataSourceManager.m
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DataSourceManager.h"

@implementation DataSourceManager

@synthesize dataSources;

-(DataSourceManager*)initWithLocationManager:(CLLocationManager *)loc {
    [super init];
    _locationManager = loc;
    [self initDataSources];
    return self;
}

-(void)initDataSources {
    DataSource *wikipedia = [[DataSource alloc] initWithLocationManager:_locationManager title:@"Wikipedia" jsonUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG"];
    DataSource *twitter = [[DataSource alloc] initWithLocationManager:_locationManager title:@"Twitter" jsonUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm"];
    wikipedia.activated = YES;
    
    [dataSources addObject: wikipedia];
    [dataSources addObject: twitter];
}

@end
