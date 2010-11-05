//
//  MapViewController.m
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController
@synthesize map  = _map;

- (void)viewDidLoad {
	[super viewDidLoad];
	MKCoordinateRegion newRegion;
	CLLocationManager* locmng = [[[CLLocationManager alloc]init]autorelease];
	
	newRegion.center.latitude = locmng.location.coordinate.latitude;
	newRegion.center.longitude = locmng.location.coordinate.longitude;
	newRegion.span.latitudeDelta = 0.01;
	newRegion.span.longitudeDelta = 0.01;
	[self.map setRegion:newRegion animated:YES];
}
@end
