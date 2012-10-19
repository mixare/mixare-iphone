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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "manager/DataSourceManager.h"
#import "manager/DownloadManager.h"
#import "ListViewController.h"
#import "AugmentedGeoViewController.h"
#import "data/JsonHandler.h"
#import "MapViewController.h"
#import "MarkerView.h"
#import "Radar.h"
#import "MoreViewController.h"
#import "SourceViewController.h"

@interface MixareAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,ARViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *_locManager;
    DataSourceManager *_dataSourceManager;
    DownloadManager *_downloadManager;
    
    UIWindow *window;
	UITabBarController *_tabBarController;
	CMMotionManager *motionManager;
	ListViewController *_listViewController;
	MapViewController *_mapViewController;
	AugmentedGeoViewController *augViewController;
	JsonHandler *jHandler;
	UISlider *_slider;
	UISegmentedControl *_menuButton;
	IBOutlet UIView *menuView;
    UILabel *_valueLabel;
    UILabel *nordLabel;
    UILabel *maxRadiusLabel;
    MoreViewController *_moreViewController;
    SourceViewController *_sourceViewController;
    @private
    BOOL beforeWasLandscape;
    IBOutlet UIView *notificationView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) DataSourceManager *dataSourceManager;
@property (nonatomic, retain) DownloadManager *downloadManager;
@property (nonatomic, retain) IBOutlet ListViewController *listViewController;
@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;
@property (nonatomic, retain) IBOutlet UISlider * slider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *menuButton;
@property (nonatomic, retain) IBOutlet MoreViewController *moreViewController;
@property (nonatomic, retain) IBOutlet SourceViewController *sourceViewController;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;


- (void)iniARView;
- (MarkerView*)viewForCoordinate:(PoiItem*)coordinate;
- (void)mapData;
- (void)initControls;
- (void)setViewToLandscape:(UIView*)viewObject;
- (void)setViewToPortrait:(UIView*)viewObject;
@end
