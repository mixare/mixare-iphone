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
	_closeButton.frame = CGRectMake(270, 20, 50, 25);
	_closeButton.backgroundColor = [UIColor clearColor];
	[_closeButton setTitle:@"Menu" forState:UIControlStateNormal];
	[_closeButton setAlpha:0.7];
	[_closeButton addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventTouchUpInside];
	[self.imgPicker.view addSubview:_closeButton];
	[self presentModalViewController:self.imgPicker animated:YES];
	if(motionManager == nil){
		motionManager = [[[CMMotionManager alloc]init]autorelease];
	}
	referenceAttitude = nil;
	motionManager.deviceMotionUpdateInterval = 0.01;
	[self enableDeviceMotion];
	[self getDeviceGLRotationMatrix];
}

-(void) enableDeviceMotion{
	CMDeviceMotion *deviceMotion = motionManager.deviceMotion;      
	CMAttitude *attitude = deviceMotion.attitude;
	referenceAttitude = [attitude retain];
	[motionManager startDeviceMotionUpdates];
}

-(void) getDeviceGLRotationMatrix{
	CMDeviceMotion *deviceMotion = motionManager.deviceMotion;      
	CMAttitude *attitude = deviceMotion.attitude;
	
	if (referenceAttitude != nil){
		[attitude multiplyByInverseOfAttitude:referenceAttitude];
	}
	CMRotationMatrix rot=attitude.rotationMatrix;
	[self printRotationMatrix:rot];
	//[self printprintRoationMatrix:rot];
	/*rotMatrix[0]=rot.m11; rotMatrix[1]=rot.m21; rotMatrix[2]=rot.m31;  rotMatrix[3]=0;
	rotMatrix[4]=rot.m12; rotMatrix[5]=rot.m22; rotMatrix[6]=rot.m32;  rotMatrix[7]=0;
	rotMatrix[8]=rot.m13; rotMatrix[9]=rot.m23; rotMatrix[10]=rot.m33; rotMatrix[11]=0;
	rotMatrix[12]=0;      rotMatrix[13]=0;      rotMatrix[14]=0;       rotMatrix[15]=1;*/
}

-(void) printRoationMatrix: (CMRotationMatrix) matrix{
	//NSLog(@" %f   %f   %f  ||| %f   %f   %f |||  %f   %f    %f", matrix.m11,matrix.m21, matrix.m13, matrix.m21, matrix.m22, matrix.m23, matrix.m31, matrix.m32, matrix.m33);
	NSLog(@"%f first value",matrix.m11);
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ((interfaceOrientation==UIInterfaceOrientationPortrait)||(interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)){
		return NO;
	}
	if ((interfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation==UIInterfaceOrientationLandscapeRight)){
		return YES;
	}

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
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

-(void)initMarkersWithJSONData: (NSString*) jsonData{
	NSDictionary* data = [jsonData JSONValue];
	NSArray* geonames = [data objectForKey:@"geonames"];
	if(markers == nil){
		markers = [[[NSMutableArray alloc]init]autorelease];
	}
	for(NSDictionary *geoname in geonames){
		Marker * marker = [Marker initMarkerWithTitle:[geoname objectForKey:@"title"] latitude:[[geoname objectForKey:@"lat"]floatValue] longitude:[[geoname objectForKey:@"lng"]floatValue] altitude:[[geoname objectForKey:@"elevation"]floatValue] url:[geoname objectForKey:@"wikipediaUrl"]];
		
		[markers addObject:marker];
		marker = nil;
		[marker release];
		NSLog(@"Marker added with Title: %@", [geoname objectForKey:@"title"]);
	}

}

-(void)showMarkers{
	UIView * markerLayer = [[UIView alloc]initWithFrame:_imgPicker.view.frame];
	for(int i = 0; i < [markers count]; i++){
		
	}
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
