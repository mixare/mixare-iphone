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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
}

- (void)createARWebView {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.text = @"Close";
    closeButton.alpha = .6;
    closeButton.titleLabel.textColor = [UIColor blackColor];
    CGRect infoFrame;
    CGRect webFrame;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        infoFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0);
        webFrame = CGRectMake(0, 25, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
        closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 25);
    } else {
        closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 60, 0, 60, 25);
        infoFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        webFrame = CGRectMake(0, 25, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width / 2);
    }
    UIView *infoView = [[UIView alloc] initWithFrame:infoFrame];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
    webView.alpha = .7;
    [infoView addSubview:webView];
    NSURL *requestURL = [NSURL URLWithString:_url];
    
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseIn forView:infoView cache:YES];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        infoView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
    } else {
        infoView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width / 2);
    }
    infoView.alpha = .8;
    [[self superview] addSubview:infoView];
    [infoView addSubview:closeButton];
    [UIView commitAnimations];
    webActivated = YES;
}

- (void)buttonClick:(id)sender {
    UIView *viewToRemove = (UIView*)[sender superview];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5]; 
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.superview cache:YES];
    viewToRemove.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0);
    viewToRemove.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
    webActivated = NO;
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
