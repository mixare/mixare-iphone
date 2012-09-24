//
//  Position.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "Position.h"

@implementation Position

-(Position*) initWithTitle:(NSString *)tit withSummary:(NSString *)sum withUrl:(NSString *)u withLatitude:(CGFloat)lat withLongitude:(CGFloat)lon withAltitude:(CGFloat)alt {
    self = [super init];
    if(self) {
        title = tit;
        summary = sum;
        url = u;
        latitude = lat;
        longitude = lon;
        altitude = alt;
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
}

@end
