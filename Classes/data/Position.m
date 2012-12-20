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
//
//  Position.m
//  Mixare
//
//  Created by Aswin Ly on 24-09-12.
//

#import "Position.h"
#import "DataSource.h"

@implementation Position

@synthesize mapViewAnnotation, poiItem, title, summary, url, source, longitude, altitude, latitude, image;

- (id)initWithTitle:(NSString*)tit withSummary:(NSString*)sum withUrl:(NSString*)u withLatitude:(float)lat withLongitude:(float)lon withAltitude:(CGFloat)alt withSource:(DataSource*)sour {
    self = [super init];
    title = tit;
    summary = sum;
    url = u;
    latitude = lat;
    longitude = lon;
    altitude = alt;
    source = sour;
    [self initMarkerAndMapAnnotation];
    return self;
}

- (void)initMarkerAndMapAnnotation {
    mapViewAnnotation = [[MapViewAnnotation alloc] initWithLatitude:latitude longitude:longitude position:self];
    [mapViewAnnotation setTitle:title];
    [mapViewAnnotation setSubTitle:summary];
    poiItem = [[PoiItem alloc] initWithLatitude:latitude longitude:longitude altitude:altitude position:self];
}

- (void)setMarker:(NSString*)marker {
    if ([self isImageUrl:marker]) {
        NSURL *urls = [NSURL URLWithString:marker];
        NSData *data = [NSData dataWithContentsOfURL:urls];
        image = [self imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(30, 30)];
    } else if (marker != nil) {
        image = [UIImage imageNamed:marker];
    }
}

- (BOOL)isImageUrl:(NSString*)urls {
    NSArray *elements = @[@"http", @"."];
    for (NSString *element in elements) {
        if ([urls rangeOfString:element].location == NSNotFound) {
            return NO;
        }
    }
    NSArray *possibleFiles = @[@"jpeg", @"png", @"jpg", @"_mini"];
    for (NSString *file in possibleFiles) {
        if ([urls rangeOfString:file].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)imageWithImage:(UIImage *)img scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
