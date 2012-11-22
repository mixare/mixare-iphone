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
#define CAMERA_TRANSFORM 1.12412
#define degreesToRadian(x) (M_PI * (x) / 180.0)
 
@implementation MixareAppDelegate

@synthesize _dataSourceManager, _locationManager, toggleMenu, pluginDelegate, alertRunning;

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
    NSLog(@"STARTING");
	[self initManagers];
    beforeWasLandscape = NO;
	[window makeKeyAndVisible];
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
        toggleMenu = YES;
        [self openARView];
        //[self openMenu]; Start with ARview instead of menu
    }
    return YES;
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
		_locationManager.distanceFilter = 3.0;
		//[_locationManager startUpdatingLocation];
	}
}

/***
 *
 *  Refresh/Redownload data for Application [HEAD]
 *
 ***/
- (void)refresh {
    float radius = 1;
    if (_slider != nil) {
        radius = _slider.value;
    }
    [_downloadManager download:[_dataSourceManager getActivatedSources] currentLocation:_locationManager.location currentRadius:radius];
}

/***
 *
 *  Initialize UIBarTitles
 *
 ***/
- (void)initUIBarTitles {
    ((UITabBarItem *)(_tabBarController.tabBar.items)[0]).title = NSLocalizedString(@"Camera", @"First tabbar icon");
    ((UITabBarItem *)(_tabBarController.tabBar.items)[1]).title = NSLocalizedString(@"Sources", @"2nd tabbar icon");
    ((UITabBarItem *)(_tabBarController.tabBar.items)[2]).title = NSLocalizedString(@"List View", @"3rd tabbar icon");
    ((UITabBarItem *)(_tabBarController.tabBar.items)[3]).title = NSLocalizedString(@"Map", @"4th tabbar icon");
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
    if (augViewController == nil) {
        augViewController = [[AugmentedGeoViewController alloc] init];
    }
    [self initControls];
    [self refresh];
    [augViewController viewWillAppear:YES];
	augViewController.scaleViewsBasedOnDistance = YES;
	augViewController.minimumScaleFactor = 0.6;
	augViewController.rotateViewsBasedOnPerspective = YES;
    if (_dataSourceManager.dataSources != nil) {
        [augViewController refresh:[_dataSourceManager getActivatedSources]];
    }
    augViewController.centerLocation = _locationManager.location;
    [notificationView removeFromSuperview];
    if (toggleMenu) {
        [augViewController.view addSubview:_menuButton];
    }
    [augViewController.view addSubview:_sliderButton];
    [augViewController.view addSubview:_slider];
    [augViewController.view addSubview:_valueLabel];
    [augViewController.view addSubview:nordLabel];
    [augViewController.view addSubview:maxRadiusLabel];
	[augViewController startListening:_locationManager];
    if (pluginDelegate != nil) {
        [augViewController.view addSubview:backToPlugin];
    }
    window.rootViewController = augViewController;
}

/***
 *
 *  Close ARView
 *
 ***/
- (void)closeARView {
    [augViewController closeCameraView];
    [augViewController.view removeFromSuperview];
    augViewController = nil;
    window.rootViewController = nil;
}

/***
 *
 *  Response when radius value has been changed
 *
 ***/
- (void)valueChanged:(id)sender {
	NSLog(@"val: %f",_slider.value);
    _valueLabel.text = [NSString stringWithFormat:@"%f", _slider.value];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", _slider.value] forKey:@"radius"];
    [self closeARView];
	[self refresh];
    [self openARView];
	NSLog(@"POIS CHANGED");
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
    [self closeARView];
    [pluginDelegate run:self];
}

/***
 *
 *  OPEN MENU
 *
 ***/
- (void)openMenu {
    [_menuButton removeFromSuperview];
    [self closeARView];
    _tabBarController.selectedIndex = 1;
    [self openTabSources];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    window.rootViewController = _tabBarController;
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

/***
 *
 *  OPEN RADIUS SLIDE
 *
 ***/
- (void)openRadiusSlide {
    if (_slider.hidden || maxRadiusLabel.hidden) {
        _slider.hidden = NO;
        maxRadiusLabel.hidden = NO;
    } else {
        _slider.hidden = YES;
        maxRadiusLabel.hidden = YES;
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
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    ProgressHUD *hud = [[ProgressHUD alloc] initWithLabel:@"Loading..."];
    [hud show];
    if (tabBarController.selectedIndex != 0) {
        [augViewController.locationManager stopUpdatingHeading];
        [augViewController.locationManager stopUpdatingLocation];
        [_locationManager stopUpdatingLocation];
        [self refresh]; //download new data
    }
    switch (tabBarController.selectedIndex) {
        case 0:
            NSLog(@"Opened camera tab");
            [self openTabCamera];
            break;
        case 1:
            NSLog(@"Opened source tab");
            [self openTabSources];
            break;
        case 2:
            NSLog(@"Opened POI list tab");
            [self openTabPOI];
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
            NSLog(@"Out of range");
            break;
    }
    [hud dismiss];
}

/***
 *
 *  TAB 0: CAMERA
 *
 ***/
- (void)openTabCamera {
    notificationView.center = window.center;
    [window addSubview:notificationView];
    [self openARView];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

/***
 *
 *  TAB 1: SOURCE LIST
 *
 ***/
- (void)openTabSources {
    if (_dataSourceManager.dataSources != nil) {
        [_sourceViewController setDownloadManager:_downloadManager];
        [_sourceViewController refresh:_dataSourceManager];
    }
}

/***
 *
 *  TAB 2: POI LIST
 *
 ***/
- (void)openTabPOI {
    if (_dataSourceManager.dataSources != nil) {
        [_listViewController setDownloadManager:_downloadManager];
        [_listViewController refresh:[_dataSourceManager getActivatedSources]];
    } else {
        NSLog(@"Data POI List not set");
    }
}

/***
 *
 *  TAB 3: MAP
 *  Fill actual Data Positions to map
 *
 ***/
- (void)openTabMap {
    if(_dataSourceManager.dataSources != nil){
        [_mapViewController refresh:[_dataSourceManager getActivatedSources]];
        NSLog(@"Data Annotations map set");
    }
}

/***
 *
 *  TAB 4: MORE
 *  Get current position data
 *
 ***/
- (void)openTabMore {
    NSLog(@"latitude: %f", _locationManager.location.coordinate.latitude);
    [_moreViewController showGPSInfo:_locationManager.location];
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
    //Maintain the camera in Landscape orientation [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        [self setViewToLandscape:augViewController.view];
        beforeWasLandscape = YES;
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait && beforeWasLandscape) {
        [self setViewToPortrait:augViewController.view];
        beforeWasLandscape = NO;
    }
    //    deletNSLog(@"DID ROTATE");
    
}

/***
 *
 *  Transform view to landscape
 *  @param viewObject
 *
 ***/
- (void)setViewToLandscape:(UIView*)viewObject {
    [viewObject setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2)];
    CGAffineTransform cgCTM = CGAffineTransformMakeRotation(degreesToRadian(90));
    viewObject.transform = cgCTM;
    viewObject.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    _menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 130, 0, 65, 30);
    _sliderButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 65, 0, 65, 30);
    _slider.frame = CGRectMake(62, 5, 288, 23);
    maxRadiusLabel.frame = CGRectMake(318, 28, 30, 10);
    backToPlugin.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 130, 35, 130, 30);
}

/***
 *
 *  Transform view to portrait
 *  @param viewObject
 *
 ***/
- (void)setViewToPortrait:(UIView*)viewObject {
    viewObject.transform = CGAffineTransformMakeRotation(degreesToRadian(0)); // set current transform
    viewObject.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    backToPlugin.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 35, 130, 30);
    _menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 0, 65, 30);
    _sliderButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 0, 65, 30);
    _slider.frame = CGRectMake(62, 5, 128, 23);
    maxRadiusLabel.frame = CGRectMake(158, 25, 30, 12);
}

/***
 *
 *  Initialize UI controls
 *
 ***/
- (void)initControls {
    backToPlugin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backToPlugin.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 35, 130, 30);
    [backToPlugin setTitle:NSLocalizedString(@"Main menu",nil) forState:UIControlStateNormal];
    [backToPlugin setTintColor:[UIColor grayColor]];
    [backToPlugin setAlpha:0.7];
    [backToPlugin addTarget:self action:@selector(pluginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 0, 65, 30);
    [_menuButton setTitle:NSLocalizedString(@"Menu",nil) forState:UIControlStateNormal];
    _menuButton.alpha = 0.7;
    [_menuButton addTarget:self action:@selector(menuClicked:)forControlEvents:UIControlEventTouchUpInside];
    
    _sliderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sliderButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 0, 65, 30);
    [_sliderButton setTitle:NSLocalizedString(@"Radius",nil) forState:UIControlStateNormal];
    _sliderButton.alpha = 0.7;
    [_sliderButton addTarget:self action:@selector(radiusClicked:)forControlEvents:UIControlEventTouchUpInside];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(62, 5, 128, 23)];
    _slider.alpha = 0.7;
    [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.hidden = YES;
    _slider.minimumValue = 1.0;
    _slider.maximumValue = 80.0;
    _slider.continuous= NO;
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.5, 64, 45, 12)];
    _valueLabel.backgroundColor = [UIColor blackColor];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.font = [UIFont systemFontOfSize:10.0];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    
    nordLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 2, 10, 10)];
    nordLabel.backgroundColor = [UIColor blackColor];
    nordLabel.textColor = [UIColor whiteColor];
    nordLabel.font = [UIFont systemFontOfSize:8.0];
    nordLabel.textAlignment = NSTextAlignmentCenter;
    nordLabel.text = @"N";
    nordLabel.alpha = 0.8;
	
    maxRadiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 25, 30, 12)];
    maxRadiusLabel.backgroundColor = [UIColor blackColor];
    maxRadiusLabel.textColor = [UIColor whiteColor];
    maxRadiusLabel.font = [UIFont systemFontOfSize:10.0];
    maxRadiusLabel.textAlignment = NSTextAlignmentCenter;
    maxRadiusLabel.text = @"80 km";
    maxRadiusLabel.hidden = YES;
    
    float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"] floatValue];
    if (radius <= 0 || radius > 100) {
        _slider.value = 5.0;
        _valueLabel.text= @"5.0 km";
    } else {
        _slider.value = radius;
        NSLog(@"RADIUS VALUE: %f", radius);
        _valueLabel.text= [NSString stringWithFormat:@"%.2f km", radius];
    }
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

