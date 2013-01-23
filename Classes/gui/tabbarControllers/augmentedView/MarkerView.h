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
#import "PopUpWebView.h"

//Info view of a poi. Shoved when tapping on a por in the cam view. opens a webview of the poi
@interface MarkerView : UIView {
    UIView *viewTouched;
    NSString *_url;
    UIView *loadView;
    UIButton *btn;
    PopUpWebView *popUpView;
    UILabel *titleLabel;
}

@property (nonatomic, strong) UIView *viewTouched;
@property (nonatomic, strong) NSString *url;
@property PopUpWebView *popUpView;
@property (nonatomic, retain) UILabel *titleLabel;

- (id)initWithWebView:(PopUpWebView*)webView;

@end
