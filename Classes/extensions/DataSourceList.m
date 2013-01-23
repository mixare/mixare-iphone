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
//  DataSourceList.m
//  Mixare
//
//  Created by Aswin Ly on 15-11-12.
//

/***                                                        ***
 *                                                            *
 *  --- INITIALIZE YOUR DATASOURCES [before starting app] --- *
 *                                                            *
 ***                                                        ***/

#import "DataSourceList.h"
#import "DataSource.h"

@implementation DataSourceList

@synthesize dataSources;

static DataSourceList *dataSourceList;

+ (void)initialize {
    if (self == [DataSourceList class]) {
        dataSourceList = [[DataSourceList alloc] init];
    }
}

+ (id)getInstance {
    return dataSourceList;
}

- (id)init {
    self = [super init];
    if (self) {
        dataSources = [[NSMutableArray alloc] init];
        [self initDataSources];
    }
    return self;
}

/***
 *
 *  ADD YOUR DATASOURCES WITH addDataSource method.
 *  App will pre-load your data
 *  Users can't delete your source if you call 'locked' true/yes.
 *
 *  GOOD TO KNOW: DataSource title will be used to match with the right DataProcessor 
 *  (not needed when your JSON result structure/encoding is the same as the Mixare standard).
 *  
 *  TIP:        If your datasource url has GET-parameters (for dynamic results), 
 *              you can replace these parameters with dummy-parameters
 *              so the Super-class JsonData.h (of the used DataProcessor) will recognizes and replaces with realtime data.
 *
 *  PARAMS:     Latitude:   PARAM_LAT
 *              Longitude:  PARAM_LON
 *              Altitude:   PARAM_ALT
 *              Radius:     PARAM_RAD
 *
 *  EXAMPLE:    example.com/json/theurl.php?lat=PARAM_LAT&lon=PARAM_LON&alt=PARAM_ALT&radius=PARAM_RAD
 *
 ***/
- (void)initDataSources {
    
}

- (void)addDataSource:(NSString*)title dataUrl:(NSString*)url lockDeletable:(BOOL)lock {
    [dataSources addObject:[[DataSource alloc] initTitle:title jsonUrl:url locked:lock]];
}

@end
