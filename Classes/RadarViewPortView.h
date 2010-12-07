//
//  RadarViewPortView.h
//  Mixare
//
//  Created by Obkircher Jakob on 23.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Radar.h"

@interface RadarViewPortView : UIView {
    @private
    BOOL isFirstAccess;
    float newAngle;
    float referenceAngle;
}
@property (nonatomic) float newAngle;
@property (nonatomic) float referenceAngle;
@end
