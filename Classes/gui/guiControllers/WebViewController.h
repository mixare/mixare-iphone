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

#import <UIKit/UIKit.h>

//View controller for the webview when tapping on a poi in the listview
//confrom to the UIWebViewDelegate protocol so the webview can stop showing the loading information when all data is downloaded
@interface WebViewController : UIViewController <UIWebViewDelegate>{
    //url which will be opened
	NSString *_url;
    //the webview
    IBOutlet UIWebView *_webView;
    //Loading view with activity indicator
    IBOutlet UIView *loadView;
}

@property (nonatomic, strong) NSString *url;

@end
