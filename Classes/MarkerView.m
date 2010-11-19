//
//  MarkerView.m
//  Mixare
//
//  Created by Obkircher Jakob on 19.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MarkerView.h"


@implementation MarkerView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    //[super touchesBegan:<#touches#> withEvent:<#event#>];
    UITouch *touch = [touches anyObject];
    if([touch tapCount] == 2)
    {
        // ... take some action on a double tap ...
    }
    else
    {
        NSLog(@"Touch began");
    }
}


- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    NSLog(@"touch ended");
}

- (void)dealloc {
    [super dealloc];
}


@end
