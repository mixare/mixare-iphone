//
//  Radar.h
//  Mixare
//
//  Created by Obkircher Jakob on 22.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RADIUS 30.0
#import "ARGeoCoordinate.h"
@interface Radar : UIView {
    NSArray * _pois;
    float _range;
    float _radius;
}
@property (nonatomic,retain) NSArray * pois;
@property (nonatomic, readonly) float range;
@property (nonatomic) float radius;

@end
