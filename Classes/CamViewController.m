//
//  CamViewController.m
//  Mixare
//
//  Created by jakob on 25.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "CamViewController.h"
#define CAMERA_TRANSFORM 1.22412

@implementation CamViewController
@synthesize imgPicker = _imgPicker;
@synthesize closeButton = _closeButton;
@synthesize tabController = _tabController;
@synthesize window= _window;

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
}

*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[self setImgPicker: [[UIImagePickerController alloc] init] ];
	[[self imgPicker] setSourceType: UIImagePickerControllerSourceTypeCamera];
	self.imgPicker.cameraViewTransform = CGAffineTransformScale(self.imgPicker.cameraViewTransform, CAMERA_TRANSFORM, CAMERA_TRANSFORM);
	[[self imgPicker] setShowsCameraControls:NO];
	[[self imgPicker] setNavigationBarHidden:YES];
	[[self imgPicker] setDelegate:self];
	_closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_closeButton.frame = CGRectMake(270, 0, 50, 25);
	_closeButton.backgroundColor = [UIColor clearColor];
	[_closeButton setTitle:@"Menu" forState:UIControlStateNormal];
	[_closeButton setAlpha:0.7];
	[_closeButton addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventTouchUpInside];
	[self.imgPicker.view addSubview:_closeButton];
	[self presentModalViewController:self.imgPicker animated:YES];
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)willRotateToInterfaceOrientation:
(UIInterfaceOrientation)orientation
							   duration:(NSTimeInterval)duration {
	CGRect appFrame;
	appFrame.origin = CGPointMake(0.0f, 0.0f);
	if ((orientation == UIInterfaceOrientationLandscapeLeft) ||
		(orientation == UIInterfaceOrientationLandscapeRight))
		appFrame.size = CGSizeMake(480.0f, 300.0f);
	else
		appFrame.size = CGSizeMake(320.0f, 460.0f);
	
	[self.view setFrame:appFrame];
}

-(void)buttonClick:(id)sender{
	NSLog(@"Close button pressed");
	[[[self imgPicker] view] removeFromSuperview];
	[[self imgPicker] release];
	_tabController.selectedIndex = 1;
	[_window addSubview:_tabController.view];
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
	[self.imgPicker release];
}


@end
