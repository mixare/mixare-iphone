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


@synthesize viewTouched, url=_url;

//The basic idea here is to intercept the view which is sent back as the firstresponder in hitTest.
//We keep it preciously in the property viewTouched and we return our view as the firstresponder.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"Hit Test");
    viewTouched = [super hitTest:point withEvent:event];
    return self;
}

//Then, when an event is fired, we log this one and then send it back to the viewTouched we kept, and voilà!!! :)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Began");
    //[viewTouched touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Moved");
    //[viewTouched touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Ended");
    //[viewTouched touchesEnded:touches withEvent:event];
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.text = @"Close";
    //closeButton.titleLabel.backgroundColor = [UIColor grayColor];
    //closeButton.backgroundColor = [UIColor grayColor];
    closeButton.alpha = .6;
    closeButton.titleLabel.textColor = [UIColor blackColor];
    CGRect infoFrame;
    CGRect webFrame;
	CGRect buttobFrame;
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait){
        infoFrame = CGRectMake(0, 480, 0, 0);
        webFrame = CGRectMake(0, 25, 320, 220);
        closeButton.frame = CGRectMake(260, 0, 60, 25);
		buttobFrame= CGRectMake(0, 0, 320, 240);
    }else{
        closeButton.frame = CGRectMake(420, 0, 60, 25);
        infoFrame = CGRectMake(0, 320, 0, 0);
        webFrame = CGRectMake(0, 25, 480, 160);
		buttobFrame= CGRectMake(0, 0, 480, 160);
    }
    UIView * infoView = [[UIView alloc]initWithFrame:infoFrame];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:webFrame];
	//UIButton * transparentButton = [[UIButton alloc]initWithFrame:buttobFrame];
	//[transparentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //webView.delegate = self;
    webView.alpha = .7;
    [infoView addSubview:webView];
    NSURL *requestURL = [NSURL URLWithString:_url];
	NSLog(@"URL IN WEBVIEW: %@",_url);
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj]; 
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1]; 
    [UIView setAnimationTransition:UIViewAnimationCurveEaseIn forView:infoView cache:YES];
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait){
        infoView.frame= CGRectMake(0, 240, 320, 240);
    }else{
       infoView.frame= CGRectMake(0, 160, 480, 160); 
    }
    infoView.alpha = .8;
    [[self superview] addSubview:infoView];
    [infoView addSubview:closeButton];
	//[infoView addSubview:transparentButton];
    [UIView commitAnimations];
}

-(void)buttonClick:(id) sender{
    UIView *viewToRemove = (UIView*)[sender superview];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5]; 
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.superview cache:YES];
    viewToRemove.frame = CGRectMake(0, 480, 0, 0);
    viewToRemove.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


- (void)dealloc {
    [super dealloc];
    [viewTouched release];
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
