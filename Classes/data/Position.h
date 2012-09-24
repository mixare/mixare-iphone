//
//  Position.h
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject {
    NSString* title;
    NSString* summary;
    NSString* url;
    CGFloat latitude;
    CGFloat longitude;
    CGFloat altitude;
}

-(Position*) initWithTitle:(NSString*)tit withSummary:(NSString*)sum withUrl:(NSString*)u withLatitude:(CGFloat)lat withLongitude:(CGFloat)lon withAltitude:(CGFloat)alt;

@end
