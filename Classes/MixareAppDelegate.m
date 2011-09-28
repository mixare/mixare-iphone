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
#import "data/JsonHandler.h"
#import "reality/PhysicalPlace.h"
#import "data/DataSource.h"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
 

@implementation MixareAppDelegate
@synthesize mapViewController = _mapViewController;
@synthesize window;
@synthesize tabBarController = _tabBarController;
@synthesize locManager = _locManager;
@synthesize data = _data;
@synthesize listViewController = _listViewController;
@synthesize slider = _slider;
@synthesize menuButton = _menuButton;
@synthesize moreViewController = _moreViewController;
@synthesize sourceViewController = _sourceViewController;
@synthesize valueLabel = _valueLabel;

#pragma mark -
#pragma  mark URL Handler
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	NSLog(@"the url: %@", [url absoluteURL]);
	if (!url) {  return NO; }
    NSString *URLString = [url absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:URLString forKey:@"extern_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[self downloadData];
    return YES;
}
#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//[window addSubview:_tabBarController.view];
	[self initLocationManager];
	//[NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
   
	[[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"Wikipedia"];
   
	[self downloadData];
	[self iniARView];
    beforeWasLandscape = NO;
    
	[window makeKeyAndVisible];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    ((UITabBarItem *)[_tabBarController.tabBar.items objectAtIndex:0]).title = NSLocalizedString(@"Camera", @"First tabbar icon");
    ((UITabBarItem *)[_tabBarController.tabBar.items objectAtIndex:1]).title = NSLocalizedString(@"Sources", @"2 tabbar icon");
    ((UITabBarItem *)[_tabBarController.tabBar.items objectAtIndex:2]).title = NSLocalizedString(@"List View", @"3 tabbar icon");
    ((UITabBarItem *)[_tabBarController.tabBar.items objectAtIndex:3]).title = NSLocalizedString(@"Map", @"4 tabbar icon");
    NSString* licenseText = [[NSUserDefaults standardUserDefaults] objectForKey:@"mixaresFirstLounch"];
    if([licenseText isEqualToString:@""] || licenseText ==nil ) {
        UIAlertView *addAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"License",nil)message:@"Copyright (C) 2010- Peer internet solutions\n This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. \n This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. \nYou should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
        [addAlert show];
        [addAlert release];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"mixaresFirstLounch"];
    }
    
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

-(void) didRotate:(NSNotification *)notification{ 
    //Maintain the camera in Landscape orientation [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft){
        [self setViewToLandscape:augViewController.view];
        beforeWasLandscape = YES;
    }
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait && beforeWasLandscape){
        [self setViewToPortrait:augViewController.view];
        beforeWasLandscape = NO;
    }
//    deletNSLog(@"DID ROTATE");
    
}

-(void)setViewToLandscape:(UIView*)viewObject {
    [viewObject setCenter:CGPointMake(160, 240)];
    CGAffineTransform cgCTM = CGAffineTransformMakeRotation(degreesToRadian(90));
    viewObject.transform = cgCTM;
    viewObject.bounds = CGRectMake(0, 0, 480, 320);
    _slider.frame = CGRectMake(62, 5, 288, 23);
    _menuButton.frame = CGRectMake(350, 0, 130, 30);
    maxRadiusLabel.frame = CGRectMake(318, 28, 30, 10);
}

-(void)setViewToPortrait:(UIView*)viewObject{
    CGAffineTransform tr = viewObject.transform; // get current transform (portrait)
    tr = CGAffineTransformRotate(tr, -(M_PI / 2.0)); // rotate -90 degrees to go portrait
    viewObject.transform = tr; // set current transform 
    CGRectMake(0, 0, 320, 480);
    [viewObject setCenter:CGPointMake(240, 160)];
    _menuButton.frame =  CGRectMake(190, 0, 130, 30);
    _slider.frame = CGRectMake(62, 5, 128, 23);
    maxRadiusLabel.frame= CGRectMake(158, 25, 30, 12);
}

-(void)markerClick:(id)sender{
    NSLog(@"MARKER");
}


-(void) iniARView{
    //if(augViewController == nil){
        augViewController = [[AugmentedGeoViewController alloc] init];
    //}
	
	augViewController.delegate = self;
	
	augViewController.scaleViewsBasedOnDistance = YES;
	augViewController.minimumScaleFactor = 0.6;
	
	augViewController.rotateViewsBasedOnPerspective = YES;
	
	[self mapData];
    
	if(_locManager != nil){
		augViewController.centerLocation = _locManager.location;
	}
    [self initControls];
    [notificationView removeFromSuperview];
    [augViewController.view addSubview:_menuButton];
    [augViewController.view addSubview:_slider];
    [augViewController.view addSubview:_valueLabel];
    [augViewController.view addSubview:nordLabel];
    [augViewController.view addSubview:maxRadiusLabel];
	[augViewController startListening];
    
    window.rootViewController = augViewController;
}

-(void) initControls{
    _menuButton = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Menu",nil), NSLocalizedString(@"Radius",nil),nil]];
    _menuButton.segmentedControlStyle = UISegmentedControlStyleBar;
    CGRect buttonFrame;
    CGRect sliderFrame;
    CGRect valueFrame;
    buttonFrame = CGRectMake(190, 0, 130, 30);
    sliderFrame = CGRectMake(62, 5, 128, 23);
    valueFrame = CGRectMake(8.5, 64, 45, 12);
    _menuButton.frame = buttonFrame;
    _menuButton.alpha = 0.65;
    [_menuButton addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventValueChanged];
    
    _slider = [[UISlider alloc]initWithFrame:sliderFrame];
    _slider.alpha = 0.7;  
    [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.hidden = YES;
    _slider.minimumValue = 1.0;
    _slider.maximumValue = 80.0;
    _slider.continuous= NO;
    
    _valueLabel = [[UILabel alloc] initWithFrame:valueFrame];
    _valueLabel.backgroundColor = [UIColor blackColor];
    _valueLabel.textColor= [UIColor whiteColor];
    _valueLabel.font = [UIFont systemFontOfSize:10.0];
    _valueLabel.textAlignment= UITextAlignmentCenter;
    
    nordLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 2, 10, 10)];
    nordLabel.backgroundColor = [UIColor blackColor];
    nordLabel.textColor= [UIColor whiteColor];
    nordLabel.font = [UIFont systemFontOfSize:8.0];
    nordLabel.textAlignment= UITextAlignmentCenter;
    nordLabel.text = @"N";
    nordLabel.alpha = 0.8;
	
    maxRadiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(158, 25, 30, 12)];
    maxRadiusLabel.backgroundColor = [UIColor blackColor];
    maxRadiusLabel.textColor= [UIColor whiteColor];
    maxRadiusLabel.font = [UIFont systemFontOfSize:10.0];
    maxRadiusLabel.textAlignment= UITextAlignmentCenter;
    maxRadiusLabel.text = @"80 km";
    maxRadiusLabel.hidden = YES;
    
    float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"] floatValue];
    if(radius <= 0 || radius > 100){
        _slider.value = 5.0;
        _valueLabel.text= @"5.0 km";
    }else{
        _slider.value = radius;
        NSLog(@"RADIUS VALUE: %f", radius);
        _valueLabel.text= [NSString stringWithFormat:@"%.2f km",radius];
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
		PhysicalPlace *tempCoordinate;
		for(NSDictionary *poi in _data){
			CGFloat alt = [[poi valueForKey:@"alt"]floatValue];
			if(alt ==0.0){
				alt = _locManager.location.altitude+50;
			}
			float lat = [[poi valueForKey:@"lat"]floatValue];
			float lon = [[poi valueForKey:@"lon"]floatValue];
			
			tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:alt horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
			tempCoordinate = [PhysicalPlace coordinateWithLocation:tempLocation];
			tempCoordinate.title = [poi valueForKey:@"title"];
			tempCoordinate.source = [poi valueForKey:@"source"];
            tempCoordinate.url = [poi valueForKey:@"url"];
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
	//Adding logic if mixare is called outside by specific url
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
   // NSString * external_url;
//	NSString * external_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"extern_url"];
//	//NSLog(@"EXTERNAL URL IN DOWNLOAD: %@", external_url);
//	
//	if(external_url != nil){
//		//Application is called with a url starting with mixare://
//		NSLog(@"Downloading Mixare data");
//		NSURL * url = [NSURL URLWithString:[external_url stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"mixare://"]]];
//		NSLog(@"URL %@", url );
//		mixareData = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//		NSLog(@"Downloading Mixare done %@", mixareData);
//		if(mixareData != nil && ![mixareData isEqualToString:@""]){
//			[_data addObjectsFromArray:[jHandler processMixareJSONData:mixareData]];
//			NSLog(@"data count: %d", [_data count]);
//			[mixareData release];
//		}
//	}else{
		//Application is called normally
		if([self checkIfDataSourceIsEanabled:@"Wikipedia"]){
			NSLog(@"Downloading WIki data");
			NSString   *language = [[NSLocale preferredLanguages] objectAtIndex:0];
			NSLog(@"Language: %@",language);
			wikiData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"WIKIPEDIA" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:pos.altitude radius:radius Lang:language]] encoding:NSUTF8StringEncoding error:nil];
			NSLog(@"Download done");
		}else {
			wikiData = nil;
		}
		if([self checkIfDataSourceIsEanabled:@"Buzz"]){
			NSLog(@"Downloading Buzz data");
			buzzData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"BUZZ" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:700 radius:radius Lang:@"de"]]encoding:NSUTF8StringEncoding error:nil];
			NSLog(@"Download done");
		}else {
			buzzData = nil;
		}
		if([self checkIfDataSourceIsEanabled:@"Twitter"]){
			NSLog(@"Downloading Twitter data");
			twitterData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:[DataSource createRequestURLFromDataSource:@"TWITTER" Lat:pos.coordinate.latitude Lon:pos.coordinate.longitude Alt:700 radius:radius Lang:@"de"]]encoding:NSUTF8StringEncoding error:nil];
			NSLog(@"Download done");
		}else {
			twitterData = nil;
		}
		//User specific Sources .. 
		if(_sourceViewController != nil && [_sourceViewController.dataSourceArray count]>3){
			//datasource contains sources added by the user
			NSLog(@"Downloading Mixare data");
			//mixareData = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.suedtirolerland.it/api/map/getARData/?client%5Blat%5D=46.47895932197436&client%5Blng%5D=11.295661926269203&client%5Brad%5D=100&lang_id=1&project_id=15&showTypes=13%2C14&key=51016f95291ef145e4b260c51b06af61"] encoding:NSUTF8StringEncoding error:nil];
			//getting selected Source
			NSString * customURL;
			for(int i=3;i< [_sourceViewController.dataSourceArray count];i++){
				if([self checkIfDataSourceIsEanabled:[_sourceViewController.dataSourceArray objectAtIndex:i]]){
					customURL = [NSString stringWithFormat:@"http://%@",[_sourceViewController.dataSourceArray objectAtIndex:i]];
				}
			}
			NSURL * customDsURL;
			@try {
				customDsURL = [NSURL URLWithString:customURL];
				mixareData = [[NSString alloc]initWithContentsOfURL:customDsURL encoding:NSUTF8StringEncoding error:nil];
				NSLog(@"Download done");
			}
			@catch (NSException *exception) {
				NSLog(@"ERROR Downloading custom ds");
			}
			@finally {
				
			}
			
			
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
//	}
    
	[jHandler release];
}

-(void)valueChanged:(id)sender{
	NSLog(@"val: %f",_slider.value);
    _valueLabel.text = [NSString stringWithFormat:@"%f", _slider.value];
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
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
		//[window  addSubview:_tabBarController.view];
        window.rootViewController = _tabBarController;
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	}else if(_menuButton.selectedSegmentIndex ==  1){
		_slider.hidden = NO;
        _valueLabel.hidden = NO;
        maxRadiusLabel.hidden=NO;
	}
}



#define BOX_WIDTH 150
#define BOX_HEIGHT 100

- (MarkerView *)viewForCoordinate:(PoiItem *)coordinate {
	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	MarkerView *tempView = [[MarkerView alloc] initWithFrame:theFrame];
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //tempView.backgroundColor = [UIColor grayColor];
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
    if([coordinate.source isEqualToString:@"BUZZ"]){
        //wrapping long buzz messages
        titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        titleLabel.numberOfLines = 0;
        CGRect frame = [titleLabel frame];
        CGSize size = [titleLabel.text sizeWithFont:titleLabel.font	constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeClip];
        frame.size.height = size.height;
        [titleLabel setFrame:frame];
    }else{
        //Markers get automatically resized
        [titleLabel sizeToFit];
	}
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0,  pointView.image.size.height + 5, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	
    tempView.url = coordinate.url;
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
	[pointView release];
	[titleLabel release];
    tempView.userInteractionEnabled = YES;
    
	return [tempView autorelease];
}

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
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"extern_url"];
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
    
    if(tabBarController.selectedIndex == 0 ){
        notificationView.center = window.center;
        [window addSubview:notificationView];
		[augViewController removeCoordinates:_data];
        [self downloadData];
        [self iniARView];
        [augViewController startListening];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	}else{
        [augViewController.locationManager stopUpdatingHeading];
        [augViewController.locationManager stopUpdatingLocation];
        [_locManager stopUpdatingLocation];
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
                [_listViewController.tableView reloadData];
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
        if(tabBarController.selectedIndex == 4 ){
            NSLog(@"latitude: %f", augViewController.locationManager.location.coordinate.latitude);
            [_moreViewController showGPSInfo:augViewController.locationManager.location.coordinate.latitude lng:augViewController.locationManager.location.coordinate.longitude alt:augViewController.locationManager.location.altitude speed:augViewController.locationManager.location.speed date:augViewController.locationManager.location.timestamp];
        }
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

