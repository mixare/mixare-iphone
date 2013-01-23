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
#import "WebViewController.h"
#import "Resources.h"

@implementation MoreViewController

- (id)init {
    self = [super initWithNibName:@"MoreViewController" bundle:[[Resources getInstance] bundle]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [licenseButton addTarget:self action:@selector(licenseClick:) forControlEvents:UIControlEventTouchUpInside];
    [logoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(id)sender {
    //open the mixare webpage
    if (self.navigationController != nil) {
        WebViewController *targetViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
        targetViewController.url = @"http://www.mixare.org";
        [[self navigationController] pushViewController:targetViewController animated:YES];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mixare.org"]];
    }
}

- (void)licenseClick:(id)sender {
    [self showLicense];
}

- (void)showGPSInfo:(CLLocation*)loc {
    lon.text = [NSString stringWithFormat:@"%.4f", loc.coordinate.longitude];
    lat.text = [NSString stringWithFormat:@"%.4f", loc.coordinate.latitude];
    alt.text = [NSString stringWithFormat:@"%.4f", loc.altitude];
    speed.text = [NSString stringWithFormat:@"%.4f", loc.speed];
    accuracy.text = [NSString stringWithFormat:@"%.4f", loc.horizontalAccuracy];
    
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4]; 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    date.font = [UIFont fontWithName:@"Arial" size:13.0f];
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

- (void)showLicense {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"License", @"Localizable", [[Resources getInstance] bundle], @"") message:@"Copyright (C) 2010- Peer internet solutions\n This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. \n This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. \nYou should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/" delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [[Resources getInstance] bundle], @"") otherButtonTitles:nil, nil];
    [addAlert show];
}

@end
