//
//  MapViewController.h
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController {
	IBOutlet MKMapView* _map;
	NSMutableArray *_data;
}
@property(nonatomic,retain)MKMapView *map;
@property (nonatomic, retain) NSMutableArray * data;
-(void) mapDataToMapAnnotations;

@end
