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

//Is the Viewcontroller for the more tab in the tabbar
@interface MoreViewController : UIViewController {
    //custom button with the mixare logo .. oens the mixare webpage
    IBOutlet UIButton *logoButton;
    //Label which contains the latitude value
    IBOutlet UILabel *lat;
    //Label which contains the longitude value
    IBOutlet UILabel *lon;
    //Label which contains the altitude value
    IBOutlet UILabel *alt;
    //Label which contains the accuracy value
    IBOutlet UILabel *accuracy;
    //Label which contains the speed value
    IBOutlet UILabel *speed;
    //Label which contains the date value of the last valid gps signal
    IBOutlet UILabel *date;
    IBOutlet UIButton *licenseButton;
}

//action method which is added to the logobutton .. open the mixare webpage
- (void)buttonClick:(id)sender;
- (void)licenseClick:(id)sender;
//method which write gps information in the according labels
- (void)showGPSInfo:(CLLocation*)loc;

@end
 