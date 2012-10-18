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

/*
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

*/
@implementation MapViewController
@synthesize map  = _map;

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
	[locmng release];
    if (_currentAnnotations == nil) {
        _currentAnnotations = [[NSMutableArray alloc] init];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)refresh:(NSMutableArray*)dataSources {
    [self removeAllAnnotations];
    for (DataSource* data in dataSources) {
        [self addAnnotationsFromDataSource:data];
    }
}

- (void)addAnnotationsFromDataSource:(DataSource *)data{
	if(data.positions != nil){
		for(Position *pos in data.positions){
            [self.map addAnnotation:pos.mapViewAnnotation];
            [_currentAnnotations addObject:pos.mapViewAnnotation];
		}
	}
}

- (void)removeAllAnnotations {
    [self.map removeAnnotations:_currentAnnotations];
    [_currentAnnotations removeAllObjects];
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
