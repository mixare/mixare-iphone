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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MixVector.h"

@interface PhysicalPlace : NSObject <MKAnnotation> {
	CGFloat _lat;
	CGFloat _lon;
	CGFloat _altitude;
	NSString * title;
	NSString * _subTitle;
}
@property (nonatomic) CGFloat lat; 
@property (nonatomic) CGFloat lon;
@property (nonatomic) CGFloat altitude; 
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * subTitle;

+(void)calcDestinationWithLat1: (CGFloat) lat1Deg lon1: (CGFloat) lon1Deg bear: (CGFloat) bear destination: (CGFloat) d place: (PhysicalPlace*) pl;

+(void)convLocToVecWithLocation: (CLLocation*) org place: (PhysicalPlace*) gp vector: (MixVector*) v;
+(CGFloat)distanceBetweenLong1: (CGFloat) long1 lat1: (CGFloat) lat1 long2: (CGFloat)long2 lat2: (CGFloat)lat2;

-(BOOL) isClickValidX: (float)x y: (float) y;

+(MixVector*)convLocToVecWithLocation: (CLLocation*) org place: (PhysicalPlace*) gp;
@end
