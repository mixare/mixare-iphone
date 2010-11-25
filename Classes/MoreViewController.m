//
//  MoreViewController.m
//  Mixare
//
//  Created by Obkircher Jakob on 23.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"


@implementation MoreViewController
@synthesize loc = _loc;






// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if(tabSwitch != nil){
        [tabSwitch addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventValueChanged];
    }
    if(logoButton != nil){
        [logoButton addTarget:self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    generalInfoView.hidden=YES;
}

-(IBAction)switchView:(id) sender{
    if(tabSwitch.selectedSegmentIndex == 1){
        // licenseInfo part
        textView.hidden = YES;
        generalInfoView.hidden = NO;
        NSLog(@"latitude: %f", _loc.coordinate.latitude);
        
    }else if (tabSwitch.selectedSegmentIndex==0){
        //General Text
        textView.hidden = NO;
        generalInfoView.hidden = YES;
    }
}

-(IBAction)buttonClick: (id) sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mixare.org"]];
}

-(void)showGPSInfo:(float)latitude lng: (float)lng alt: (float) altitude speed:(float) sp date: (NSDate*) stamp {
    NSLog(@"show val latitude: %f", lat);
    lon.text = [NSString stringWithFormat:@"%f", lng];
    lat.text = [NSString stringWithFormat:@"%f", latitude];
    alt.text = [NSString stringWithFormat:@"%f", altitude];
    speed.text = [NSString stringWithFormat:@"%f",sp];
    //accuracy.text = [NSString stringWithFormat:@"%f", _locManager.desiredAccuracy];
    
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4]; 
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease]; 
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    date.text = [dateFormatter stringFromDate:stamp];
    
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


- (void)dealloc {
    [super dealloc];
    [tabSwitch release];
    [textView release];
    [logoButton release];
    [generalInfoView release];
}


@end
