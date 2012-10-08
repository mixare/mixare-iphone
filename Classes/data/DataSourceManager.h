//
//  DataSourceManager.h
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@interface DataSourceManager : NSObject{
	CLLocationManager *_locationManager;
    NSMutableArray *dataSources;
}

@property (nonatomic, retain) NSMutableArray *dataSources;

-(DataSourceManager*) initWithLocationManager:(CLLocationManager*)loc;

@end
