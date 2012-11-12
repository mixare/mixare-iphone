//
//  PluginList.m
//  Mixare
//
//  Created by Aswin Ly on 12-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "PluginList.h"
#import "WikipediaProcessor.h"
#import "TwitterProcessor.h"
#import "GoogleAddressesProcessor.h"
#import "MixareProcessor.h"


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
        [self initPlugins];
    }
    return self;
}

/***
 *
 *  ADD YOUR PLUGINS HERE
 *  Only possible with interface: DataInput, DataConverter, CustomFrontView or PluginEntryPoint
 *
 ***/
- (void)initPlugins {
    plugins = [[NSMutableArray alloc] init];
    [plugins addObject:[[WikipediaProcessor alloc] init]];
    [plugins addObject:[[TwitterProcessor alloc] init]];
    [plugins addObject:[[GoogleAddressesProcessor alloc] init]];
    [plugins addObject:[[MixareProcessor alloc] init]]; 
}

- (NSMutableArray*)getPluginList {
    return plugins;
}

@end
