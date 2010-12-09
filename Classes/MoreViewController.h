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
#import <CoreLocation/CoreLocation.h>

@interface MoreViewController : UIViewController {
    IBOutlet UISegmentedControl * tabSwitch;
    IBOutlet UITextView * textView;
    IBOutlet UIButton * logoButton;
    IBOutlet UIView * generalInfoView;
    IBOutlet UILabel * lat;
    IBOutlet UILabel * lon;
    IBOutlet UILabel * alt;
    IBOutlet UILabel * accuracy;
    IBOutlet UILabel * speed;
    IBOutlet UILabel * date;
    CLLocation * _loc;
    
}
@property (nonatomic, retain) CLLocation* loc;
-(void)buttonClick: (id) sender;
-(void)switchView:(id) sender;
-(void)showGPSInfo:(float)lat lng: (float)lon alt: (float) alt speed:(float) speed date: (NSDate*) date;
@end
 