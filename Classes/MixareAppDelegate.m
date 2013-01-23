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

#import "MixareAppDelegate.h"
#import "PluginLoader.h"
#import "PluginList.h"
#import "ProgressHUD.h"
#import "Resources.h"
 
@implementation MixareAppDelegate

@synthesize toggleReturnButton, toggleMenuButton, pluginDelegate, alertRunning, _dataSourceManager, window;

static ProgressHUD *hud;

#pragma mark -
#pragma mark Application lifecycle

- (void)runApplication {
    hud = [[ProgressHUD alloc] initWithLabel:NSLocalizedStringFromTableInBundle(@"Loading...", @"Localizable", [[Resources getInstance] bundle], @"")];
    NSLog(@"STARTING");
	[self initManagers];
    beforeWasLandscape = NO;
    toggleReturnButton = NO;
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (window != nil) {
        NSLog(@"Created window");
    }
    [self createInterface];
	[window makeKeyAndVisible];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    [self firstBootLicenseText];
    if ([[[PluginLoader getInstance] getPluginsFromClassName:nil] count] > 0) {
        startPlugin = [[PluginLoader getInstance] getPluginsFromClassName:nil];
        NSLog(@"Pre-plugins to run: %d", [startPlugin count]);
        for (id<PluginEntryPoint> plugin in startPlugin) {
            [plugin run:self];
        }
    } else {
        [[[PluginList getInstance] defaultBootstrap] run:self];
    }
    [self temporaryView];
}

- (void)temporaryView {
    if (window.rootViewController == nil) {
        window.rootViewController = [[UIViewController alloc] init];
    }
    // small issue, temporary fix
}

- (void)standardViewInitialize {
    [self refresh];
    [self openARView];
    [self closeHud];
}

/***
 *
 *  Initialize managers
 *
 ***/
- (void)initManagers {
    _locationManager = [[CLLocationManager alloc] init];
    _downloadManager = [[DownloadManager alloc] init];
    _dataSourceManager = [[DataSourceManager alloc] init];
}

/***
 *
 *  Refresh/Redownload data for Application [HEAD]
 *
 ***/
- (void)refresh {
    float radius = 1;
    if (augViewController.slider != nil) {
        radius = augViewController.slider.value;
    }
    [_downloadManager download:[_dataSourceManager getActivatedSources] currentLocation:_locationManager.location currentRadius:radius];
}

/***
 *
 *  Initialize ARView
 *
 ***/
- (void)openARView {
    augViewController = [[AugmentedGeoViewController alloc] initWithLocationManager:_locationManager];
    if (_dataSourceManager.dataSources != nil) {
        [augViewController refresh:[_dataSourceManager getActivatedSources]];
    }
    augViewController.centerLocation = _locationManager.location;
    [self initControls];
    self.window.rootViewController = augViewController;
}

/***
 *
 *  Response when radius value has been changed
 *
 ***/
- (void)valueChanged {
    [hud show];
	[self performSelectorInBackground:@selector(reloadCamera) withObject:nil];
}

- (void)reloadCamera {
    augViewController.valueLabel.text = [NSString stringWithFormat:@"%f", augViewController.slider.value];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", augViewController.slider.value] forKey:@"radius"];
    [augViewController closeCameraView];
	[self refresh];
    [self openARView];
	NSLog(@"POIS CHANGED");
    [hud dismiss];
}

/***
 *
 *  Response when radius button has been pressed
 *
 ***/
- (void)radiusClicked:(id)sender {
    [self openRadiusSlide];
}

/***
 *
 *  Response when menu button has been pressed
 *
 ***/
- (void)menuClicked:(id)sender {
    [self openMenu];
}

/***
 *
 *  Response when plugin button on AR has been pressed
 *
 ***/
- (void)pluginButtonClicked:(id)sender {
    [hud show];
    [self performSelectorInBackground:@selector(openPlugin) withObject:nil];
}

- (void)openPlugin {
    [augViewController closeCameraView];
    [pluginDelegate run:self];
    [hud dismiss];
}

/***
 *
 *  OPEN MENU
 *
 ***/
- (void)openMenu {
    [hud show];
    [augViewController closeCameraView];
    // here you are assigning the tb as the root viewcontroller
    tabBarController.selectedIndex = 1;
    [self performSelectorInBackground:@selector(openTabSources) withObject:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    self.window.rootViewController = tabBarController;
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

/***
 *
 *  OPEN RADIUS SLIDE
 *
 ***/
- (void)openRadiusSlide {
    if (augViewController.slider.hidden || augViewController.maxRadiusLabel.hidden) {
        augViewController.slider.hidden = NO;
        augViewController.maxRadiusLabel.hidden = NO;
    } else {
        augViewController.slider.hidden = YES;
        augViewController.maxRadiusLabel.hidden = YES;
    }
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/***
 *
 *  Optional UITabBarControllerDelegate method
 *  Tab pages
 *  @param tabBarController
 *  @param viewController
 *
 ***/
- (void)tabBarController:(UITabBarController *)tabController didSelectViewController:(UIViewController *)viewController {
    [hud show];
    if (tabController.selectedIndex != 0) {
        [_locationManager stopUpdatingLocation];
        [_locationManager stopUpdatingHeading];
    }
    switch (tabController.selectedIndex) {
        case 0:
            NSLog(@"Opened camera tab");
            [self performSelectorInBackground:@selector(openTabCamera) withObject:nil];
            break;
        case 1:
            NSLog(@"Opened source tab");
            [self performSelectorInBackground:@selector(openTabSources) withObject:nil];
            break;
        case 2:
            NSLog(@"Opened POI list tab");
            [self performSelectorInBackground:@selector(openTabPOI) withObject:nil];
            break;
        case 3:
            NSLog(@"Opened map tab");
            [self openTabMap];
            break;
        case 4:
            NSLog(@"Opened more info tab");
            [self openTabMore];
            break;
        default:
            [hud dismiss];
            NSLog(@"Out of range");
            break;
    }
}

/***
 *
 *  TAB 0: CAMERA
 *
 ***/
- (void)openTabCamera {
    [self refresh];
    [self openARView];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [hud dismiss];
}

/***
 *
 *  TAB 1: SOURCE LIST
 *
 ***/
- (void)openTabSources {
    if (_dataSourceManager.dataSources != nil) {
        [self refresh];
        [sourceViewController setDownloadManager:_downloadManager];
        [sourceViewController refresh:_dataSourceManager];
    }
    [hud dismiss];
}

/***
 *
 *  TAB 2: POI LIST
 *
 ***/
- (void)openTabPOI {
    if (_dataSourceManager.dataSources != nil) {
        [self refresh];
        [listViewController setDownloadManager:_downloadManager];
        [listViewController refresh:[_dataSourceManager getActivatedSources]];
    } else {
        NSLog(@"Data POI List not set");
    }
    [hud dismiss];
}

/***
 *
 *  TAB 3: MAP
 *  Fill actual Data Positions to map
 *
 ***/
- (void)openTabMap {
    if (_dataSourceManager.dataSources != nil) {
        [self refresh];
        [mapViewController refresh:[_dataSourceManager getActivatedSources]];
        NSLog(@"Data Annotations map set");
    }
    [hud dismiss];
}

/***
 *
 *  TAB 4: MORE
 *  Get current position data
 *
 ***/
- (void)openTabMore {
    [moreViewController showGPSInfo:_locationManager.location];
    [hud dismiss];
}


/***
 *  --------------------------------------
 *
 *      STANDARD SETTINGS - here below
 *
 *  --------------------------------------
 ***/

#pragma mark -
#pragma mark Memory management

/***
 *
 *  Device rotation check
 *  @param notification
 *
 ***/
- (void)didRotate:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait && beforeWasLandscape) {
        [augViewController setViewToPortrait];
        beforeWasLandscape = NO;
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        [augViewController setViewToLandscape];
        beforeWasLandscape = YES;
    }
}

/***
 *
 *  Initialize UI controls
 *
 ***/
- (void)initControls {    
    [augViewController initInterface];
    if (!toggleMenuButton) {
        augViewController.menuButton.hidden = YES;
    }
	[augViewController startListening:_locationManager];
    if (!toggleReturnButton) {
        augViewController.backToPlugin.hidden = YES;
    }
    [augViewController.slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    [augViewController.sliderButton addTarget:self action:@selector(radiusClicked:)forControlEvents:UIControlEventTouchUpInside];
    [augViewController.menuButton addTarget:self action:@selector(menuClicked:)forControlEvents:UIControlEventTouchUpInside];
    [augViewController.backToPlugin addTarget:self action:@selector(pluginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        [augViewController setViewToLandscape];
        beforeWasLandscape = YES;
    }
}

- (void)showHud {
    [hud show];
}

- (void)closeHud {
    [hud dismiss];
}

- (void)createInterface {
    NSBundle *bundle = [[Resources getInstance] bundle];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.selectedIndex = 0;
    UIViewController *cameraButtonDummy = [[UIViewController alloc] init];
    [cameraButtonDummy setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Camera", @"Localizable", [[Resources getInstance] bundle], @"") image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"camera" ofType:@"png"]] tag:0]];
    
    NSString *sourceTitle = NSLocalizedStringFromTableInBundle(@"Sources", @"Localizable", [[Resources getInstance] bundle], @"");
    UINavigationController *sourceNavigationController = [[UINavigationController alloc] init];
    sourceNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    sourceViewController = [[SourceViewController alloc] init];
    [sourceViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:sourceTitle image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_datasource" ofType:@"png"]]  tag:1]];
    sourceViewController.navigationItem.title = sourceTitle;
    sourceNavigationController.viewControllers = [NSArray arrayWithObjects:sourceViewController, nil];
    
    NSString *listTitle = NSLocalizedStringFromTableInBundle(@"List View", @"Localizable", [[Resources getInstance] bundle], @"");
    UINavigationController *listNavigationController = [[UINavigationController alloc] init];
    listNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    listViewController = [[ListViewController alloc] init];
    [listViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:listTitle image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"list" ofType:@"png"]]  tag:2]];
    listViewController.navigationItem.title = listTitle;
    listNavigationController.viewControllers = [NSArray arrayWithObjects:listViewController, nil];
    
    NSString *mapTitle = NSLocalizedStringFromTableInBundle(@"Map", @"Localizable", [[Resources getInstance] bundle], @"");
    UINavigationController *mapNavigationController = [[UINavigationController alloc] init];
    mapNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    mapViewController = [[MapViewController alloc] init];
    [mapViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:mapTitle image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"map" ofType:@"png"]] tag:3]];
    mapViewController.navigationItem.title = mapTitle;
    mapNavigationController.viewControllers = [NSArray arrayWithObjects:mapViewController, nil];
    
    UINavigationController *moreNavigationController = [[UINavigationController alloc] init];
    moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    moreViewController = [[MoreViewController alloc] init];
    [moreViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:4]];
    moreViewController.navigationItem.title = NSLocalizedStringFromTableInBundle(@"General Info", @"Localizable", [[Resources getInstance] bundle], @"");
    moreNavigationController.viewControllers = [NSArray arrayWithObjects:moreViewController, nil];
    
    UIBarButtonItem *license = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"License", @"Localizable", [[Resources getInstance] bundle], @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showLicense)];
    moreViewController.navigationItem.rightBarButtonItem = license;
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:cameraButtonDummy, sourceNavigationController, listNavigationController, mapViewController, moreViewController, nil]];
}

/***
 *
 *  License text at first start
 *
 ***/
- (void)firstBootLicenseText {
    NSString *licenseText = [[NSUserDefaults standardUserDefaults] objectForKey:@"mixaresFirstLaunch"];
    if ([licenseText isEqualToString:@""] || licenseText == nil) {
        [self showLicense];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"mixaresFirstLaunch"];
    }
}

- (void)showLicense {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"License", @"Localizable", [[Resources getInstance] bundle], @"") message:@"Copyright (C) 2010- Peer internet solutions\n This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. \n This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. \nYou should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/" delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [[Resources getInstance] bundle], @"") otherButtonTitles:nil, nil];
    [addAlert show];
}

@end

