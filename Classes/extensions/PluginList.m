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
#import "MixareProcessor.h"
#import "BootView.h"

@implementation PluginList

@synthesize plugins;

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

- (void)initPlugins {
    
}

- (void)addPlugin:(id)plugin {
    [plugins addObject:plugin];
}

- (id<DataProcessor>)defaultProcessor {
    return [[MixareProcessor alloc] init];
}

- (id<PluginEntryPoint>)defaultBootstrap {
    return [[BootView alloc] init];
}

- (id<DataInput>)defaultInput {
    //return [[StandardInput alloc] init];
    return nil;
}

@end
