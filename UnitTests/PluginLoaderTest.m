//
//  PluginLoaderTest.m
//  Mixare
//
//  Created by Aswin Ly on 12-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "PluginLoaderTest.h"
#import "PluginList.h"

@implementation PluginLoaderTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatePluginLoader {
    STAssertNotNil([PluginLoader getInstance], @"Singleton not created");
}

- (void)testLoadPluginList {
    PluginLoader *loader = [PluginLoader getInstance];
    [loader addArrayOfPlugins:[[PluginList getInstance] getPluginList]];
    STAssertNotNil([loader getPluginsFromClassName:@"DataProcessor"], @"Plugins not loaded");
}

@end
