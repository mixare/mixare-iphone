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
//  PluginList.m
//  Mixare
//
//  Created by Aswin Ly on 12-11-12.
//

/***                                         ***
 *                                             *
 *  --- INITIALIZE YOUR PLUGINS HERE BELOW --- *
 *                                             *
 ***                                         ***/

#import "PluginList.h"
#import "WikipediaProcessor.h"
#import "TwitterProcessor.h"
#import "GoogleAddressesProcessor.h"
#import "ArenaProcessor.h"
#import "MixareProcessor.h"
#import "StandardInput.h"
#import "BarcodeInput.h"
#import "StartWithMeDemo.h"

@implementation PluginList

static PluginList *pluginList;

+ (void)initialize {
    if (self == [PluginList class]) {
        pluginList = [[PluginList alloc] init];
    }
}

+ (id)getInstance {
    return pluginList;
}

- (id)init {
    self = [super init];
    if (self) {
        plugins = [[NSMutableArray alloc] init];
        [self initPlugins];
    }
    return self;
}

/***
 *
 *  ADD YOUR PLUGINS HERE
 *  Only possible with interface/protocol: DataInput, DataProcessor or PluginEntryPoint
 *
 ***/
- (void)initPlugins {
    [plugins addObject:[[WikipediaProcessor alloc] init]];
    [plugins addObject:[[TwitterProcessor alloc] init]];
    [plugins addObject:[[GoogleAddressesProcessor alloc] init]];
    [plugins addObject:[[ArenaProcessor alloc] init]];
    [plugins addObject:[[MixareProcessor alloc] init]];
    [plugins addObject:[[StandardInput alloc] init]];
    [plugins addObject:[[BarcodeInput alloc] init]];
    [plugins addObject:[[StartWithMeDemo alloc] init]];
}

- (NSMutableArray*)getPluginList {
    return plugins;
}

@end
