//
//  StartMain.h
//  Mixare
//
//  Created by Aswin Ly on 19-11-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceManager.h"
#import "DownloadManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol StartMain

@property (nonatomic, retain) DataSourceManager *_dataSourceManager;
@property (nonatomic, retain) DownloadManager *_downloadManager;
@property (nonatomic, retain) CLLocationManager *_locationManager;

- (void)openARView;
- (void)openMenu;

@end
