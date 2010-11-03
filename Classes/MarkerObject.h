//
//  MarkerObject.h
//  Mixare
//
//  Created by jakob on 29.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface MarkerObject : UIView {
	NSString * _text;
	Circle * _circle;
}
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Circle * circle;
@end
