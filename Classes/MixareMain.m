//
//  MixareMain.m
//  Mixare
//
//  Created by Aswin Ly on 16-01-13.
//  Copyright (c) 2013 Peer GmbH. All rights reserved.
//

#import "MixareMain.h"

@implementation MixareMain

- (id)init {
    self = [super init];
    MixareAppDelegate *delegate = [[MixareAppDelegate alloc] init];
    [delegate runApplication];
    return self;
}

@end
