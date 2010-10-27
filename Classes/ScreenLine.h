//
//  ScreenLine.h
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScreenLine : NSObject {
	float _x,_y;
}
@property (nonatomic) float x,y; 
-(void)setWithX: (float) x y: (float) y;
-(void) rotateWithValue: (float) t;
-(void) addX: (float) x y: (float) y;
@end
