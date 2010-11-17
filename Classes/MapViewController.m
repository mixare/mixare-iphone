//
//  MapViewController.m
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "PhysicalPlace.h"

@implementation MapViewController
@synthesize map  = _map;
@synthesize data = _data;

- (void)viewDidLoad {
	[super viewDidLoad];
	MKCoordinateRegion newRegion;
	CLLocationManager* locmng = [[CLLocationManager alloc]init];
	
	newRegion.center.latitude = locmng.location.coordinate.latitude;
	newRegion.center.longitude = locmng.location.coordinate.longitude;
	newRegion.span.latitudeDelta = 0.03;
	newRegion.span.longitudeDelta = 0.03;
	[self.map setRegion:newRegion animated:YES];
	[self mapDataToMapAnnotations];
	[locmng release];
}

-(void) mapDataToMapAnnotations{
	if(_data != nil){
		PhysicalPlace * tmpPlace;
		for(NSDictionary * poi in _data){
			tmpPlace = [[PhysicalPlace alloc]init];
			tmpPlace.title = [poi valueForKey:@"title"];
			tmpPlace.subTitle = [poi valueForKey:@"sum"];
			tmpPlace.lat = [[poi valueForKey:@"lat"]floatValue];
			tmpPlace.lon = [[poi valueForKey:@"lon"]floatValue];
			[self.map addAnnotation:tmpPlace];
			[tmpPlace release];
		}
	}
}
@end
