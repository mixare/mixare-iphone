//
//  DownloadManager.h
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

-(NSDictionary*) download:(NSString*)sourceUrl;

@end
