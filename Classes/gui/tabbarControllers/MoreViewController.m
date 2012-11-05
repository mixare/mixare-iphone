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

#import "MoreViewController.h"

@implementation MoreViewController
@synthesize loc = _loc;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (tabSwitch != nil) {
        //adding action method when tapping on button
        [tabSwitch addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    }
    if (logoButton != nil) {
        //adding action metho to logobutton
        [logoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //hidden because license info is shown firts
    generalInfoView.hidden=YES;
    //Will be generate key values in the language files which can be traduced later in every language 
    [tabSwitch setTitle:NSLocalizedString(@"License", nil) forSegmentAtIndex:0];
    [tabSwitch setTitle:NSLocalizedString(@"General Info", nil) forSegmentAtIndex:1];
}

- (void)switchView:(id)sender {
    if (tabSwitch.selectedSegmentIndex == 1) {
        // licenseInfo part
        textView.hidden = YES;
        generalInfoView.hidden = NO;        
    } else if (tabSwitch.selectedSegmentIndex == 0) {
        //General Text
        textView.hidden = NO;
        generalInfoView.hidden = YES;
    }
}

- (void)buttonClick:(id)sender {
    //open the mixare webpage
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mixare.org"]];
}

- (void)showGPSInfo:(CLLocation*)loc {
    lon.text = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    lat.text = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    alt.text = [NSString stringWithFormat:@"%f", loc.altitude];
    speed.text = [NSString stringWithFormat:@"%f", loc.speed];
    accuracy.text = [NSString stringWithFormat:@"%f", loc.horizontalAccuracy];
    
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4]; 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    date.text = [dateFormatter stringFromDate:loc.timestamp];
    
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
