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
//  PluginLoader.m
//  Mixare
//
//  Created by Aswin Ly on 12-11-12.
//

#import "PluginLoader.h"
#import "PluginList.h"

#import "DataProcessor.h"
#import "DataInput.h"
#import "PluginEntryPoint.h"

@implementation PluginLoader

static PluginLoader *pluginLoader;

+ (void)initialize {
    if (self == [PluginLoader class]){
        pluginLoader = [[PluginLoader alloc] init];
    }
}

+ (id)getInstance {
    return pluginLoader;
}

- (id)init {
    self = [super init];
    if (self) {
        plugins = [[NSMutableArray alloc] init];
        [self addArrayOfPlugins:[[PluginList getInstance] plugins]];
        [self addPlugin:[[PluginList getInstance] defaultProcessor]];
    }
    return self;
}

- (void)addPlugin:(id)plugin {
    if ([plugin conformsToProtocol:@protocol(DataProcessor)] || [plugin conformsToProtocol:@protocol(DataInput)] || [plugin conformsToProtocol:@protocol(PluginEntryPoint)])  {
        [plugins addObject:plugin];
    } else {
        NSLog(@"Plugin type not valid from class: %@", NSStringFromClass([plugin class]));
    }
}

- (void)addArrayOfPlugins:(NSMutableArray*)pluginz {
    for (id plugin in pluginz) {
        [self addPlugin:plugin];
    }
}

- (NSMutableArray*)getPluginsFromClassName:(NSString*)className {
    NSMutableArray *retrievedPlugins = [[NSMutableArray alloc] init];
    for (id plugin in plugins) {
        if ([className isEqualToString:@"DataProcessor"]) {
            if ([plugin conformsToProtocol:@protocol(DataProcessor)]) {
                [retrievedPlugins addObject:plugin];
            }
        } else if ([className isEqualToString:@"DataInput"]) {
            if ([plugin conformsToProtocol:@protocol(DataInput)]) {
                [retrievedPlugins addObject:plugin];
            }
        } else {
            if ([plugin conformsToProtocol:@protocol(PluginEntryPoint)]) {
                [retrievedPlugins addObject:plugin];
            }
        }
    }
    return retrievedPlugins;
}

@end
