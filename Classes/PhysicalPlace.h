//
//  PhysicalPlace.h
//  Mixare
//
//  Created by jakob on 21.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PhysicalPlace : NSObject <MKAnnotation> {
	NSString *  lat;
	NSString *  lon;
	NSString *  altitude;
	NSString * title;
	NSString * subTitle;
}
@property (nonatomic,retain) NSString *  lat; 
@property (nonatomic,retain) NSString *  lon;
@property (nonatomic,retain) NSString * altitude; 
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * subTitle;

+(void)calcDestinationWithLat1: (float) lat1Deg lon1: (float) lon1Deg bear: (float) bear destination: (float) d place: (PhysicalPlace*) pl;
+ (float)degreesToRadians:(float)degrees;


@end
