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
//  MixareMain.m
//  Mixare
//
//  Created by Aswin Ly on 16-01-13.
//

#import "MixareMain.h"

/***
 *
 *  [ EXAMPLE HOW TO USE MIXARE iOS LIBRARY (as sub-project) ]
 *
 *  MixareMain.m is a demo start-up class.
 *  You can use this as an example.
 *
 ***/

// Initialize Mixare library, access to usable classes
#import <Mixare/Mixare.h>

/***
 *
 *  Own custom plugins to initialize
 *  There are 3 types of plugin you can make:
 *    * Bootstrap - will starts before Mixare. (example: own start view)
 *    * DataInput - to gain datasource by users. (example: barcodescanner)
 *    * DataProcessor - to manage the obtained data from datasource. (example: manage special wikipedia data from json)
 *  
 *  Read WIKI for more information.
 *
 ***/
// Own DataProcessor plugins
#import "GoogleAddressesProcessor.h"
#import "TwitterProcessor.h"
#import "WikipediaProcessor.h"
// Own DataInput plugins
#import "StandardInput.h"
#import "BarcodeInput.h"
// Own Bootstrap plugin
// On default (without plugins) BootView.m will be loaded

@implementation MixareMain

- (id)init {
    self = [super init];
    
    // To use your pre-initialized datasources, you have to add your source to the singleton class DataSourceList
    [[DataSourceList getInstance] addDataSource:@"Wikipedia" dataUrl:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=PARAM_LAT&lng=PARAM_LON&radius=PARAM_RAD&maxRows=50&lang=PARAM_LANG" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Twitter" dataUrl:@"http://search.twitter.com/search.json?geocode=PARAM_LAT,PARAM_LON,PARAM_RADkm" lockDeletable:YES];
    [[DataSourceList getInstance] addDataSource:@"Google Addresses" dataUrl:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=PARAM_LAT,PARAM_LON&sensor=true" lockDeletable:YES];
    
    // To use your own plugins, you have to add your plugin to the singleton class PluginList
    [[PluginList getInstance] addPlugin:[[GoogleAddressesProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[TwitterProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[WikipediaProcessor alloc] init]];
    [[PluginList getInstance] addPlugin:[[StandardInput alloc] init]];
    [[PluginList getInstance] addPlugin:[[BarcodeInput alloc] init]];
    
    // [[ START MIXARE ]]
    // It will load all plugins and data sources
    MixareAppDelegate *delegate = [[MixareAppDelegate alloc] init];
    [delegate runApplication];
    return self;
}

@end
