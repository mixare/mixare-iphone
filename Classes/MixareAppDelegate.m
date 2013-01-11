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
#import "ProgressHUD.h"
 
@implementation MixareAppDelegate

@synthesize toggleMenu, pluginDelegate, alertRunning, mainWindow, _dataSourceManager;

static ProgressHUD *hud;

#pragma mark -
#pragma mark Application lifecycle

/***
 *
 *  Starting app: init application
 *  @param application
 *  @param launch options dictionary
 *
 ***/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self runApplication:nil];
    return YES;
}

- (void)runApplication:(UIWindow*)win {
    if (win != nil) {
        NSLog(@"TEST");
        window = win;
    }
    hud = [[ProgressHUD alloc] initWithLabel:NSLocalizedString(@"Loading...", nil)];
    NSLog(@"STARTING");
	[self initManagers];
    beforeWasLandscape = NO;
	[window makeKeyAndVisible];
    mainWindow = window;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    [self initUIBarTitles];
    [self firstBootLicenseText];
    if ([[[PluginLoader getInstance] getPluginsFromClassName:@"START"] count] > 0) {
        startPlugin = [[PluginLoader getInstance] getPluginsFromClassName:@"START"];
        NSLog(@"Pre-plugins to run: %d", [startPlugin count]);
        for (id<PluginEntryPoint> plugin in startPlugin) {
            [plugin run:self];
        }
    } else {
        [hud show];
        [self performSelectorInBackground:@selector(standardViewInitialize) withObject:nil];
    }
}

- (void)standardViewInitialize {
    toggleMenu = YES;
    [self refresh];
    [self openARView];
    //[self openMenu]; Start with ARview instead of menu
    [hud dismiss];
}

/***
 *
 *  Initialize managers
 *
 ***/
- (void)initManagers {
    [self initLocationManager];
    _downloadManager = [[DownloadManager alloc] init];
    _dataSourceManager = [[DataSourceManager alloc] init];
}

/***
 *
 *  Initialize location manager
 *
 ***/
- (void)initLocationManager {
	if (_locationManager == nil) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locationManager.delegate = self;
		_locationManager.distanceFilter = kCLDistanceFilterNone;
		[_locationManager startUpdatingLocation];
	}
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
 *  Initialize UIBarTitles
 *
 ***/
- (void)initUIBarTitles {
    ((UITabBarItem *)(tabBarController.tabBar.items)[0]).title = NSLocalizedString(@"Camera", @"First tabbar icon");
    ((UITabBarItem *)(tabBarController.tabBar.items)[1]).title = NSLocalizedString(@"Sources", @"2nd tabbar icon");
    ((UITabBarItem *)(tabBarController.tabBar.items)[2]).title = NSLocalizedString(@"List View", @"3rd tabbar icon");
    ((UITabBarItem *)(tabBarController.tabBar.items)[3]).title = NSLocalizedString(@"Map", @"4th tabbar icon");
}

/***
 *
 *  Response after click at marker
 *
 ***/
- (void)markerClick:(id)sender{
    NSLog(@"MARKER");
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
    window.rootViewController = augViewController;
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
    window.rootViewController = tabBarController;
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
        [augViewController.locationManager stopUpdatingHeading];
        [augViewController.locationManager stopUpdatingLocation];
        [_locationManager stopUpdatingLocation];
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
    NSLog(@"latitude: %f", _locationManager.location.coordinate.latitude);
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


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"extern_url"];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

#pragma mark -
#pragma mark Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

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
    if (!toggleMenu) {
        augViewController.menuButton.hidden = YES;
    }
	[augViewController startListening:_locationManager];
    if (pluginDelegate == nil) {
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

/***
 *
 *  License text at first start
 *
 ***/
- (void)firstBootLicenseText {
    NSString *licenseText = [[NSUserDefaults standardUserDefaults] objectForKey:@"mixaresFirstLaunch"];
    if ([licenseText isEqualToString:@""] || licenseText == nil) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"License",nil) message:@"Copyright (C) 2010- Peer internet solutions\n This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. \n This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. \nYou should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [addAlert show];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"mixaresFirstLaunch"];
    }
}

@end

