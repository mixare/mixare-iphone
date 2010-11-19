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
#define RADIUS 3.0
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//[window addSubview:_tabBarController.view];
	[self initLocationManager];
	//[NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
    NSLog(@"before");
	[[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"Wikipedia"];
    NSLog(@"after");
	[self downloadData];
	[self iniARView];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 60, 60)];
    UIButton * test = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage * markerImage;
    [test setBackgroundColor:[UIColor clearColor]];
    markerImage = [UIImage imageNamed:@"circle.png"];
    [test setBackgroundImage:markerImage forState:UIControlStateNormal];
	[test addTarget:augViewController action:@selector(markerClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:test];
    [augViewController.view addSubview:tempView];
    [test release];
	[window makeKeyAndVisible];
    
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	if(augViewController != nil){
		CLLocation *newCenter = _locManager.location;
		augViewController.centerLocation = newCenter;
		[newCenter release];
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location manager" message:@"Your Location changed for 3 meters "  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	//[alert release];
}


-(void)markerClick:(id)sender{
    NSLog(@"MARKER");
}


-(void) iniARView{
    //if(augViewController == nil){
        augViewController = [[ARGeoViewController alloc] init];
    //}
	augViewController.debugMode = NO;
	
	augViewController.delegate = self;
	
	augViewController.scaleViewsBasedOnDistance = YES;
	augViewController.minimumScaleFactor = .2;
	
	augViewController.rotateViewsBasedOnPerspective = YES;
	
	[self mapData];
    
	if(_locManager != nil){
		augViewController.centerLocation = _locManager.location;
	}
    [self initControls];
    [augViewController.view addSubview:_menuButton];
    [augViewController.view addSubview:_slider];
	[augViewController startListening];
	//[window addSubview:augViewController.view];
    window.rootViewController = augViewController;
    
}

-(void) initControls{
    
    //if(_slider == nil){
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 5, 170, 23)];
        _slider.alpha = 0.7;  
        [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.hidden = YES;
        _slider.minimumValue = 1.0;
        _slider.maximumValue = 20.0;
        _slider.continuous= NO;
    //}
	//if(_menuButton == nil){
        _menuButton = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Menü", @"Radius",nil]];
        _menuButton.segmentedControlStyle = UISegmentedControlStyleBar;
        _menuButton.frame = CGRectMake(190, 0, 130, 30);
        _menuButton.alpha = 0.65;
        [_menuButton addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventValueChanged];
	//}
    float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"] floatValue];
    if(radius <= 0 || radius > 100){
        _slider.value = 5.0;
    }else{
        _slider.value = radius;
        NSLog(@"RADIUS VALUE: %f", radius);
    }
    
        
    
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
		[augViewController addCoordinates:tempLocationArray];
		[tempLocationArray release];
	}else NSLog(@"no data received");
}

//Method wich manages the download of data specified by the user. The standard source is wikipedia. By selecting the different sources in the sources
//menu the appropriate data will be downloaded
-(BOOL)checkIfDataSourceIsEanabled: (NSString *)source{
    BOOL ret = NO;
    if(![source isEqualToString:@""]){
        if([[NSUserDefaults standardUserDefaults] objectForKey:source]!=nil){
            if([[[NSUserDefaults standardUserDefaults] objectForKey:source] isEqualToString:@"TRUE"]){
                ret = YES;
            }
        }
    }
    return ret;
}
-(void)downloadData{
	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
	jHandler = [[JsonHandler alloc]init];
	CLLocation * pos = _locManager.location;
	NSString * wikiData;
    NSString * mixareData;
    NSString * twitterData;
	NSString * buzzData;
    float radius = 3.5;
    if(_slider != nil){
        radius = _slider.value;
    }
    
    if([self checkIfDataSourceIsEanabled:@"Wikipedia"]){
        wikiData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"WIKIPEDIA" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:pos.altitude radius:radius Lang:@"de"]] encoding:NSUTF8StringEncoding error:nil];
    }else {
        wikiData = nil;
    }
    if([self checkIfDataSourceIsEanabled:@"Buzz"]){
        buzzData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"BUZZ" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:700 radius:radius Lang:@"de"]]encoding:NSUTF8StringEncoding error:nil];
    }else {
        buzzData = nil;
    }
    if([self checkIfDataSourceIsEanabled:@"Twitter"]){
        twitterData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"TWITTER" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:700 radius:radius Lang:@"de"]]encoding:NSUTF8StringEncoding error:nil];
    }else {
        twitterData = nil;
    }
    if([self checkIfDataSourceIsEanabled:@"Mixare"]){
        mixareData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.suedtirolerland.it/api/map/getARData/?client%5Blat%5D=46.47895932197436&client%5Blng%5D=11.295661926269203&client%5Brad%5D=100&lang_id=1&project_id=15&showTypes=13%2C14&key=51016f95291ef145e4b260c51b06af61"] encoding:NSUTF8StringEncoding error:nil];
    }else {
        mixareData = nil;
    }
 
    [_data removeAllObjects];
    if(wikiData != nil){
        _data= [jHandler processWikipediaJSONData:wikiData];
        NSLog(@"data count: %d", [_data count]);
        [wikiData release];
    }
    if(buzzData != nil){
        [_data addObjectsFromArray:[jHandler processBuzzJSONData:buzzData]];
        NSLog(@"data count: %d", [_data count]);
        [buzzData release];
    }
    if(twitterData != nil && ![twitterData isEqualToString:@""]){
       [_data addObjectsFromArray:[jHandler processTwitterJSONData:twitterData]]; 
        NSLog(@"data count: %d", [_data count]);
        [twitterData release];
    }
    if(mixareData != nil && ![mixareData isEqualToString:@""]){
        [_data addObjectsFromArray:[jHandler processMixareJSONData:mixareData]];
        NSLog(@"data count: %d", [_data count]);
        [mixareData release];
    }
	
    
    
    
	[jHandler release];
	//[pool release];
}

-(void)valueChanged:(id)sender{
	NSLog(@"val: %f",_slider.value);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", _slider.value]  forKey:@"radius"];
	[augViewController removeCoordinates:_data];
	[self downloadData];
    [self iniARView];
    [augViewController startListening];
    
	NSLog(@"POIS CHANGED");
	
}
-(void)buttonClick:(id)sender{
	NSLog(@"Close button pressed");
	//imgPicker.view.hidden = YES;
	//tabBarController.tabBar.hidden = NO;
	if(_menuButton.selectedSegmentIndex == 0){
		[augViewController closeCameraView];
		[_menuButton removeFromSuperview];
		[_menuButton release];
		[augViewController.view removeFromSuperview];
		[augViewController release];
		_tabBarController.selectedIndex = 1;
		[UIApplication sharedApplication].statusBarHidden = NO;
		[window  addSubview:_tabBarController.view];
	}else if(_menuButton.selectedSegmentIndex ==  1){
		_slider.hidden = NO;
	}
}



#define BOX_WIDTH 150
#define BOX_HEIGHT 100

- (MarkerView *)viewForCoordinate:(ARCoordinate *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	MarkerView *tempView = [[MarkerView alloc] initWithFrame:theFrame];
	UIButton * imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage * markerImage;
	//UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageButton setBackgroundColor:[UIColor clearColor]];
	if([coordinate.source isEqualToString:@"WIKIPEDIA"]|| [coordinate.source isEqualToString:@"MIXARE"]){
        markerImage = [UIImage imageNamed:@"circle.png"];
        [imageButton setBackgroundImage:markerImage forState:UIControlStateNormal];
		//pointView.image = [UIImage imageNamed:@"circle.png"];
	}else if([coordinate.source isEqualToString:@"TWITTER"]){
        markerImage = [UIImage imageNamed:@"twitter_logo.png"];
        [imageButton setBackgroundImage:markerImage forState:UIControlStateNormal];
		//pointView.image = [UIImage imageNamed:@"twitter_logo.png"];
	}else if([coordinate.source isEqualToString:@"BUZZ"]){
        markerImage = [UIImage imageNamed:@"buzz_logo.png"];
        [imageButton setBackgroundImage:markerImage forState:UIControlStateNormal];
		//pointView.image = [UIImage imageNamed:@"buzz_logo.png"];
	}
	
    
	//pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0-pointView.image.size.width / 2.0), 0, pointView.image.size.width, pointView.image.size.height);
	imageButton.frame = CGRectMake((int)(BOX_WIDTH / 2.0-markerImage.size.width / 2.0), 0, markerImage.size.width, markerImage.size.height);
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BOX_HEIGHT / 2.0 , BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	titleLabel.numberOfLines = 0;
	//[titleLabel sizeToFit];
	//[imageButton addTarget:augViewController action:@selector(markerClick:) forControlEvents:UIControlEventTouchUpInside];
	
	CGRect frame = [titleLabel frame];
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font	constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeClip];
    //CGFloat delta = size.height - frame.size.height;
    frame.size.height = size.height;
    [titleLabel setFrame:frame];
	
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0,  markerImage.size.height + 5, titleLabel.frame.size.width , titleLabel.frame.size.height);
	
	
	UIButton * touch = [[UIButton alloc]initWithFrame:tempView.frame];
    [touch setBackgroundColor:[UIColor clearColor]];
    [touch addTarget:augViewController action:@selector(markerClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [tempView addSubview:touch];
    
	[tempView addSubview:titleLabel];
	[tempView addSubview:imageButton];
	
	[titleLabel release];
	[touch release];
	//[imageButton release];
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
		//[self.locManager startUpdatingHeading];
	}else{
		//[self.locManager stopUpdatingHeading];
	}
	if (tabBarController.selectedIndex == 1) {
        if(_listViewController.dataSourceArray != nil){
            _listViewController.dataSourceArray =nil;
        }
	}
	if(tabBarController.selectedIndex == 2 ){
		if(_data != nil){
            _listViewController.dataSourceArray =nil;
			NSLog(@"data set");
			[_listViewController setDataSourceArray:_data];
            NSLog(@"elements in data: %d in datasource: %d", [_data count], [_listViewController.dataSourceArray count]);
		}else{
            NSLog(@"data NOOOOT set");
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
		[augViewController removeCoordinates:_data];
        [self downloadData];
        [self iniARView];
        [augViewController startListening];
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



-(void) setManualMarkers{
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
	
	[augViewController addCoordinates:tempLocationArray];
	[tempLocationArray release];
}
@end

