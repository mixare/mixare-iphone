//
//  PluginList.h
//  Mixare
//
//  Created by Aswin Ly on 12-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PluginList : NSObject {
    NSMutableArray *plugins;
}

+ (id)getInstance;
- (NSMutableArray*)getPluginList;

@end
