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


@implementation MapAnnotation
@synthesize coordinate;
@synthesize lat=_lat,lon=_lon,altitude= _altitude;
@synthesize subTitle= _subTitle, title= _title, source=_source;


- (CLLocationCoordinate2D)coordinate;{
    CLLocationCoordinate2D position;
	if (_lat != 0.0 && _lon != 0.0) {
		position.latitude = _lat;
		position.longitude = _lon;
	}else {
		position.latitude=0.0;
		position.longitude=0.0;
	}
    
    return position; 
}

@end


@implementation MapViewController
@synthesize map  = _map;
@synthesize data = _data;

- (void)viewDidLoad {
	[super viewDidLoad];
    _map.delegate= self;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(void) mapDataToMapAnnotations{
	if(_data != nil){
		MapAnnotation * tmpPlace;
		for(NSDictionary * poi in _data){
			tmpPlace = [[MapAnnotation alloc]init];
			tmpPlace.title = [poi valueForKey:@"title"];
			tmpPlace.subTitle = [poi valueForKey:@"sum"];
			tmpPlace.lat = [[poi valueForKey:@"lat"]floatValue];
			tmpPlace.lon = [[poi valueForKey:@"lon"]floatValue];
            tmpPlace.source = [poi valueForKey:@"source"];
            [self.map addAnnotation:tmpPlace];
            //[_map setNeedsLayout];
			[tmpPlace release];
		}
	}
}

//- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
//    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
//    
//    if( ((MapAnnotation*)annotation).source isEqualToString:@"WIKIPEDIA"){
//      annView.pinColor = MKPinAnnotationColorGreen;  
//    }else if(((MapAnnotation*)annotation).source isEqualToString:@"BUZZ"){
//        annView.pinColor = MKPinAnnotationColorRed;
//    }
//    annView.animatesDrop=TRUE;
//    annView.canShowCallout = YES;
//    annView.calloutOffset = CGPointMake(-5, 5);
//    return annView;
//}

@end
