//
//  StartWithMeDemo.m
//  Mixare
//
//  Created by Aswin Ly on 19-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "StartWithMeDemo.h"
#import "StartMain.h"

@implementation StartWithMeDemo

- (void)run:(id)delegate {
    id<StartMain> start = delegate;
    
    // ADD HERE YOUR PRE-STUFF
    // RUN ME BEFORE APPLICATION STARTS (Like a extra view)
    NSLog(@"LOADED START-PLUGIN 1 - TEST");
    
    [start openARView];
}

@end
