//
//  MixareAppDelegate.m
//  Mixare
//
//  Created by jakob on 05.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MixareAppDelegate.h"


@implementation MixareAppDelegate

@synthesize window;
@synthesize tabBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //[window addSubview:tabBarController.view];
	[self initCameraView];
	[window addSubview:imgPicker.view];
	//[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    return YES;
}

-(void)initCameraView{
	imgPicker = [[[UIImagePickerController alloc] init]
				 autorelease];
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;  
    imgPicker.showsCameraControls = NO;
    /* move the controller, to make the 
     statusbar visible */
    CGRect frame = imgPicker.view.frame;
    //frame.origin.y += 30;
    frame.size.height= 480.0;
    //imgPicker.view.frame = frame;
	
	//adding close butten to View
	closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	closeButton.frame = CGRectMake(270, 0, 50, 25);
	closeButton.backgroundColor = [UIColor clearColor];
	[closeButton setTitle:@"Menu" forState:UIControlStateNormal];
	[closeButton setAlpha:0.7];
	[closeButton addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventTouchUpInside];
	//closeButton.center = self.center;
	[imgPicker.view addSubview:closeButton];
}

-(void)buttonClick:(id)sender{
	NSLog(@"Close button pressed");
	[imgPicker dismissModalViewControllerAnimated:YES];
	imgPicker.view.hidden = YES;
	
	//[imgPicker.view removeFromSuperview];
	[window  addSubview:tabBarController.view];
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

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
    [tabBarController release];
    [window release];
	[imgPicker release];
	[closeButton release];
    [super dealloc];
}

@end

