/* Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/> */

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
