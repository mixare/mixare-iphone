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

#import "MarkerView.h"

@implementation MarkerView

@synthesize viewTouched, url = _url, popUpView, titleLabel;

- (id)initWithWebView:(PopUpWebView*)webView {
    self = [super init];
    popUpView = webView;
    return self;
}

//Then, when an event is fired, we log this one and then send it back to the viewTouched we kept, and voilà!!! :)
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [popUpView openUrlView:self.url];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {

}

//Touch ended -> showing info view with animation. 
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

@end
