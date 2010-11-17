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
#import "ARGeoCoordinate.h"
#import "DataSource.h"
#define TWITTER_BASE_URL @"http://search.twitter.com/search.json"
@implementation MixareAppDelegate
@synthesize mapViewController = _mapViewController;
@synthesize window;
@synthesize tabBarController = _tabBarController;
@synthesize locManager = _locManager;
@synthesize data = _data;
@synthesize listViewController = _listViewController;
@synthesize slider = _slider;
@synthesize menuButton = _menuButton;

#pragma mark -
#pragma  mark URL Handler
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	NSLog(@"the url: %@", [url absoluteString]);
	if (!url) {  return NO; }
	
    NSString *URLString = [url absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:URLString forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//[window addSubview:_tabBarController.view];
	[self initLocationManager];
	//[NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
	
	[self downloadData];
	[self iniARView];
	[window makeKeyAndVisible];
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	if(viewController != nil){
		CLLocation *newCenter = _locManager.location;
		viewController.centerLocation = newCenter;
		[newCenter release];
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location manager" message:@"Your Location changed for 3 meters "  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	//[alert release];
}
-(void)mapData{
	if(_data != nil){
		NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithCapacity:[_data count]];
		CLLocation *tempLocation;
		ARGeoCoordinate *tempCoordinate;
		for(NSDictionary *poi in _data){
			CGFloat alt = [[poi valueForKey:@"alt"]floatValue];
			if(alt ==0.0){
				alt = _locManager.location.altitude+50;
			}
			float lat = [[poi valueForKey:@"lat"]floatValue];
			float lon = [[poi valueForKey:@"lon"]floatValue];
			
			tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:alt horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
			tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
			tempCoordinate.title = [poi valueForKey:@"title"];
			tempCoordinate.source = [poi valueForKey:@"source"];
			[tempLocationArray addObject:tempCoordinate];
			[tempLocation release];
		}
		[viewController addCoordinates:tempLocationArray];
		[tempLocationArray release];
	}else NSLog(@"no data received");
}
-(void) iniARView{
	viewController = [[ARGeoViewController alloc] init];
	viewController.debugMode = NO;
	
	viewController.delegate = self;
	
	viewController.scaleViewsBasedOnDistance = YES;
	viewController.minimumScaleFactor = .2;
	
	viewController.rotateViewsBasedOnPerspective = YES;
	
	/*
	NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithCapacity:10];
	
	CLLocation *tempLocation;
	ARGeoCoordinate *tempCoordinate;
	
	CLLocationCoordinate2D location;
	location.latitude = 46.479722;
	location.longitude = 11.305693;
	
	tempLocation = [[CLLocation alloc] initWithCoordinate:location altitude:260 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:[NSDate date]];
	
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"MMM MUSEUM";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	
	//tempLocation = [[CLLocation alloc] initWithLatitude: longitude:];
	tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(46.478917, 11.344097) altitude:383 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Hasel Burg";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	//tempLocation = [[CLLocation alloc] initWithLatitude:46.43893 longitude:11.21706 ]; 
	tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(46.43893, 11.21706) altitude:1737 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
	//tempLocation.altitude = 1737;
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Penegal";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	
	tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(46.615, 11.46083) altitude:2260 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Rittner Horn";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	 
	tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(46.51159, 11.57452) altitude:2563 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
	//tempLocation.altitude =2563;
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Schlern";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(46.475468, 11.285145) altitude:293 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
	//tempLocation.altitude =2563;
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Kugel";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(46.4782, 11.2966) altitude:263 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
	//tempLocation.altitude =2563;
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
	tempCoordinate.title = @"Kirche";
	
	[tempLocationArray addObject:tempCoordinate];
	[tempLocation release];
	
	[viewController addCoordinates:tempLocationArray];
	[tempLocationArray release];
	*/
	[self mapData];
	if(_locManager != nil){
		//CLLocation *newCenter = _;
		//NSLog(@"Hight: %f ",newCenter.altitude);
		viewController.centerLocation = _locManager.location;
		//[newCenter release];
	}
	[viewController startListening];
	[self initControls];
	[viewController.view addSubview:_menuButton];
	[viewController.view addSubview:_slider];
	[window addSubview:viewController.view];
}

-(void) initControls{
	_slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 5, 170, 23)];
	_slider.alpha = 0.7;
	_menuButton = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Menü", @"Radius",nil]];
	_menuButton.segmentedControlStyle = UISegmentedControlStyleBar;
	_menuButton.frame = CGRectMake(190, 0, 130, 30);
	_menuButton.alpha = 0.65;
	[_menuButton addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventValueChanged];
	[_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	
	_slider.hidden = YES;
	_slider.minimumValue = 1.0;
	_slider.maximumValue = 20.0;
	_slider.continuous= NO;
	_slider.value = 5.0;

}

-(void) initLocationManager{
	if (_locManager == nil){
		_locManager = [[CLLocationManager alloc]init];
		_locManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locManager.delegate = self;
		_locManager.distanceFilter = 3.0;
		//[_locManager startUpdatingLocation];
	}
}

-(void)downloadData{
	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
	jHandler = [[JsonHandler alloc]init];
	CLLocation * pos = _locManager.location;
	NSString * wikiData;
	//jsonData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://mixare.org/geotest.php"]];
	NSString * buzzData;
	if(_slider != nil){
		NSLog(@"%@",[NSString stringWithFormat:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=%f&lng=%f&radius=%f&maxRows=%d&lang=de",pos.coordinate.latitude,pos.coordinate.longitude,5.5,30]);
		wikiData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=%f&lng=%f&radius=%f&maxRows=%d&lang=de",pos.coordinate.latitude,pos.coordinate.longitude,5.5,30]] encoding:NSUTF8StringEncoding error:nil];
		
		buzzData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"BUZZ" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:700 radius:5 Lang:@"de"]]];
		
	}else{
		wikiData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.geonames.org/findNearbyWikipediaJSON?lat=%f&lng=%f&radius=%f&maxRows=%d&lang=de",pos.coordinate.latitude,pos.coordinate.longitude,_slider.value,30]] encoding:NSUTF8StringEncoding error:nil];
		buzzData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"BUZZ" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:700 radius:_slider.value Lang:@"de"]]];
	}
	NSMutableArray * buzzMessages = [jHandler processBuzzJSONData:buzzData];
	_data= [jHandler processWikipediaJSONData:wikiData];
	[_data addObjectsFromArray:buzzMessages];
	
	[wikiData release];
	[jHandler release];
	//[pos release];
	//[pool release];
}
-(void)valueChanged:(id)sender{
	NSLog(@"val: %f",_slider.value);
	/*viewController.updateFrequency = 500.0;
	[self downloadData];
	[self mapData];
	viewController.updateFrequency = 1 / 20.0;*/
	[viewController removeCoordinates:_data];
	[viewController stopListening];
	[self downloadData];
	[self mapData];
	[viewController startListening];
	NSLog(@"POIS CHANGED");
	
}
-(void)buttonClick:(id)sender{
	NSLog(@"Close button pressed");
	//imgPicker.view.hidden = YES;
	//tabBarController.tabBar.hidden = NO;
	if(_menuButton.selectedSegmentIndex == 0){
		[viewController closeCameraView];
		[_menuButton removeFromSuperview];
		[_menuButton release];
		[viewController.view removeFromSuperview];
		[viewController release];
		_tabBarController.selectedIndex = 1;
		[UIApplication sharedApplication].statusBarHidden = NO;
		[window  addSubview:_tabBarController.view];
	}else if(_menuButton.selectedSegmentIndex ==  1){
		_slider.hidden = NO;
	}
}

#define BOX_WIDTH 150
#define BOX_HEIGHT 100
/*
- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
	
	//tempView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.3];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	[titleLabel sizeToFit];
	
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, 0, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
	pointView.image = [UIImage imageNamed:@"location.png"];
	pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - pointView.image.size.height / 2.0), pointView.image.size.width, pointView.image.size.height);
	
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
	
	[titleLabel release];
	[pointView release];
	
	return [tempView autorelease];
}*/
- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
	
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
	if([coordinate.source isEqualToString:@"WIKIPEDIA"]|| [coordinate.source isEqualToString:@"MIXARE"]){
		pointView.image = [UIImage imageNamed:@"circle.png"];
	}else if([coordinate.source isEqualToString:@"TWITTER"]){
		pointView.image = [UIImage imageNamed:@"twitter_logo.png"];
	}else if([coordinate.source isEqualToString:@"BUZZ"]){
		pointView.image = [UIImage imageNamed:@"buzz_logo.png"];
	}
	
	pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0-pointView.image.size.width / 2.0), 0, pointView.image.size.width, pointView.image.size.height);
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BOX_HEIGHT / 2.0 , BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	titleLabel.numberOfLines = 0;
	//[titleLabel sizeToFit];
	
	
	CGRect frame = [titleLabel frame];
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font	constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeClip];
    //CGFloat delta = size.height - frame.size.height;
    frame.size.height = size.height;
    [titleLabel setFrame:frame];
	
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0,  pointView.image.size.height + 5, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	
	
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
	
	[titleLabel release];
	[pointView release];
	
	return [tempView autorelease];
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

		
		
	}
	if(tabBarController.selectedIndex == 2 ){
		NSLog(@"inlist");
		if(_data != nil){
			NSLog(@"data set");
			[_listViewController setDataSourceArray:_data];
		}
	}
	if(tabBarController.selectedIndex == 3 ){
		NSLog(@"map");
		if(_data != nil){
			NSLog(@"data map set");
			[_mapViewController setData:_data];
			[_mapViewController mapDataToMapAnnotations];
		}
	}
	if(tabBarController.selectedIndex == 0 ){
		[self iniARView];
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
    [super dealloc];
}

@end

