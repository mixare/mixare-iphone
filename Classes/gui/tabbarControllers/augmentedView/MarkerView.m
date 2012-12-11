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

@synthesize viewTouched, url = _url, webActivated;
/*
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    NSLog(@"TOUCHED URL: %@", _url);
    viewTouched = [super hitTest:point withEvent:event];
    return self;
}*/

//Then, when an event is fired, we log this one and then send it back to the viewTouched we kept, and voilà!!! :)
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {

}

//Touch ended -> showing info view with animation. 
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    //[self pressedButton];
}

- (void)pressedButton {
    NSLog(@"Touch Ended");
    //if (!webActivated) {
        //[self createARWebView];
    //}
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    
    
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

#pragma mark WebViewDelegate
/*- (void)webViewDidStartLoad:(UIWebView *)webView{
    loadView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)]autorelease];
    loadView.center = webView.center;
    UIActivityIndicatorView * ai = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
    ai.frame = CGRectMake(42, 20, 37, 37);
    [ai startAnimating];
    [loadView addSubview:ai];
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(30, 65, 61, 21)]autorelease];
    label.text = @"Loading";
    label.backgroundColor=[UIColor grayColor];
    [loadView addSubview:label];
    loadView.center =webView.center;
    loadView.backgroundColor = [UIColor grayColor];
    loadView.alpha = 0.8;
    label.alpha = 0.8;
    [webView addSubview:loadView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    @try {
        [loadView removeFromSuperview];
    }
    @catch (NSException *exception) {
    
    }
    @finally {
    
    }
}
*/

@end
