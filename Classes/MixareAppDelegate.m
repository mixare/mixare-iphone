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
#define CAMERA_TRANSFORM 1.12412
#import "SourceViewController.h"
#import "JsonHandler.h"

@implementation MixareAppDelegate

@synthesize window;
@synthesize tabBarController = _tabBarController;
@synthesize locManager = _locManager;
@synthesize camController = _cameraController;
@synthesize view= _view;
@synthesize listViewController = _listViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[window addSubview:_tabBarController.view];
	//[self initLocationManager];
	NSLog(@"app started");
	[window makeKeyAndVisible];
    return YES;
}





-(void)buttonClick:(id)sender{
	NSLog(@"Close button pressed");
	//imgPicker.view.hidden = YES;
	//tabBarController.tabBar.hidden = NO;
	[imgPicker.view removeFromSuperview];
	[imgPicker release];
	_tabBarController.selectedIndex = 1;
	[window  addSubview:_tabBarController.view];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
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
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	if(tabBarController.tabBar.selectedItem.title ==@"Camera"){
		NSLog(@"cam mode on ");
		[self.locManager startUpdatingHeading];
	}else{
		[self.locManager stopUpdatingHeading];
	}
	if (tabBarController.selectedIndex == 1) {
		//SourceViewController * scController = [[[SourceViewController alloc]init]autorelease];
		
		NSLog(@"in sourceview controller asdasdasdasdasd");
	}
	if(tabBarController.selectedIndex == 2 ){
		[_listViewController initDataSourceWithJSONData];
	}
	
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


- (void)dealloc {
    [_tabBarController release];
    [window release];
	[imgPicker release];
	[closeButton release];
    [super dealloc];
}

@end

