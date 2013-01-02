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
#import "WebViewController.h"

@implementation WebViewController

@synthesize url = _url;

#pragma mark WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView*)webView {
    loadView.center = _webView.center;
    [_webView addSubview:loadView];
}

//When the webpage has been loaded successfully the loading view will be removed
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [loadView removeFromSuperview];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:_url];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//Load the request in the UIWebView.
	[_webView loadRequest:requestObj];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
