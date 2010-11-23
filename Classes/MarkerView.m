//
//  MarkerView.m
//  Mixare
//
//  Created by Obkircher Jakob on 19.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

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
    closeButton.frame = CGRectMake(260, 0, 60, 20);
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    closeButton.titleLabel.text = @"Close";
    //closeButton.titleLabel.backgroundColor = [UIColor grayColor];
    //closeButton.backgroundColor = [UIColor grayColor];
    closeButton.alpha = .6;
    closeButton.titleLabel.textColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView * infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 480, 0, 0)];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, 320, 220)];
    webView.alpha = .7;
    [infoView addSubview:webView];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_url]];
	NSLog(@"URL IN WEBVIEW: %@",_url);
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:requestURL];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj]; 
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5]; 
    [UIView setAnimationTransition:UIViewAnimationCurveEaseIn forView:infoView cache:YES];
    infoView.frame= CGRectMake(0, 240, 320, 240);
    infoView.alpha = .8;
    [[self superview] addSubview:infoView];
    [infoView addSubview:closeButton];
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

//-(void)removeAllInfoViews

- (void)dealloc {
    [super dealloc];
    [viewTouched release];
}


@end
