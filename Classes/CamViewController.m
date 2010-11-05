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
@synthesize locManager = _locManager;
@synthesize historyIndex= _historyIndex;
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
		motionManager = [[CMMotionManager alloc]init];
		
	}
	if (motionManager != nil) {
		CMDeviceMotion *dm = motionManager.deviceMotion;
		referenceAttitude = [dm.attitude retain];
	}
	[self initLocationManager];
	float angleX, angleY; 
	//angleX to radiants
	angleX = -90.0* M_PI / 180;
	m1 = [Matrix initMatrixWithA1:1.0 a2:0.0 a3:0.0 b1:0.0 b2:cosf(angleX) b3:-sinf(angleX) c1:0.0 c2:sinf(angleX) c3:cosf(angleX)];
	[m1 retain];
	angleY = -90.0* M_PI / 180;
	m2 = [Matrix initMatrixWithA1:1.0 a2:0.0 a3:0.0 b1:0.0 b2:cosf(angleX) b3:-sinf(angleX) c1:0.0 c2:sinf(angleX) c3:cosf(angleX)];
	m3= [Matrix initMatrixWithA1:cosf(angleY) a2:0.0 a3:sinf(angleY) b1:0.0 b2:1.0 b3:0.0 c1:-sinf(angleY) c2:0.0 c3:cosf(angleY)];
	[m2 retain];
	[m3 retain];
	m4 = [[Matrix alloc]init];
	[m4 toIdentity];
	int decilination = abs(self.locManager.heading.magneticHeading-self.locManager.heading.trueHeading);
	[m4 setToA1:cosf(angleY) a2:0.0 a3:sinf(angleY) b1:0.0 b2:1.0 b3:0.0 c1:-sinf(angleY) c2:0.0 c3:cosf(angleY)];	
	motionManager.deviceMotionUpdateInterval = 1.0;
	camera = [Camera initCameraWithHeight:480 widh:320];
	NSUInteger historyIndex = 0;
	if (motionManager.isDeviceMotionAvailable) {
		histroy = [[NSMutableArray alloc] initWithCapacity:50];
		
		/*[motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
										   withHandler: ^(CMDeviceMotion *motion, NSError *error)
		 {
			 CMAttitude *attitude = motion.attitude;
			 if (referenceAttitude != nil) {
				 [attitude multiplyByInverseOfAttitude:referenceAttitude];
			 }
			 CMRotationMatrix rotMatrix = attitude.rotationMatrix;
			 tempR = [Matrix initMatrixWithA1:rotMatrix.m11 a2:rotMatrix.m21 a3:rotMatrix.m31 b1:rotMatrix.m12 b2:rotMatrix.m22 b3:rotMatrix.m32 c1:rotMatrix.m13 c2:rotMatrix.m23 c3:rotMatrix.m33];
			 finalR = [[Matrix alloc]init];
			 [finalR toIdentity];
			 [finalR prodWithMatrix:m4];
			 [finalR prodWithMatrix:m1];
			 [finalR prodWithMatrix:tempR];
			 [finalR prodWithMatrix:m3];
			 [finalR prodWithMatrix:m2];
			 [finalR invert];
			 [histroy addObject:finalR];
			 _historyIndex += 1;
			 if(historyIndex>=50){
				 [histroy removeAllObjects];
			 }
			 [smoothR setToA1:0.0 a2:0.0 a3:0.0 b1:0.0 b2:0.0 b3:0.0 c1:0.0 c2:0.0 c3:0.0];
			 /*for(int i = 1; i <50; i++){
				 [smoothR addMatrix:((Matrix *)[histroy objectAtIndex:historyIndex])];
			 }
			 [smoothR multWithScalar:1.0/50.0];*/
			 
		/*	 NSLog(@"rotation matrix = [%f, %f, %f]", rotMatrix.m11, rotMatrix.m12,rotMatrix.m13);
			 NSLog(@"rotation matrix = [%f, %f, %f]", rotMatrix.m21, rotMatrix.m22,rotMatrix.m23);
			 NSLog(@"rotation matrix = [%f, %f, %f]", rotMatrix.m31, rotMatrix.m32,rotMatrix.m33);
			 NSLog(@"---------------------------------------------------------------------------");
			 
		}];		*/
	}
	else {
		NSLog(@"motion not available");
	}
	
}

-(void)setupMatrixes{
	float angleX, angleY; 
	//angleX to radiants
	angleX = -90.0* M_PI / 180;
	m1 = [Matrix initMatrixWithA1:1.0 a2:0.0 a3:0.0 b1:0.0 b2:cosf(angleX) b3:-sinf(angleX) c1:0.0 c2:sinf(angleX) c3:cosf(angleX)];
	angleY = -90.0* M_PI / 180;
	m2 = [Matrix initMatrixWithA1:1.0 a2:0.0 a3:0.0 b1:0.0 b2:cosf(angleX) b3:-sinf(angleX) c1:0.0 c2:sinf(angleX) c3:cosf(angleX)];
	m3= [Matrix initMatrixWithA1:cosf(angleY) a2:0.0 a3:sinf(angleY) b1:0.0 b2:1.0 b3:0.0 c1:-sinf(angleY) c2:0.0 c3:cosf(angleY)];
	m4 = [[Matrix alloc]init];
	[m4 toIdentity];
	int decilination = abs(self.locManager.heading.magneticHeading-self.locManager.heading.trueHeading);
	[m4 setToA1:cosf(angleY) a2:0.0 a3:sinf(angleY) b1:0.0 b2:1.0 b3:0.0 c1:-sinf(angleY) c2:0.0 c3:cosf(angleY)];	
}

-(void)processMotion:(CMDeviceMotion *)motion withError:(NSError *)error {
	
	//CMRotationRate rotation = motion.rotationRate;
	//motion.attitude.
	/*[UIView beginAnimations:@"MyAnimation" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:2.0]; // 5 seconds
	
	CGRect frame = cView.frame;
	frame.origin.x += -sin((motion.attitude.roll-oldRotation.roll))*50; 
	frame.origin.y += -sin((motion.attitude.pitch-oldRotation.pitch))*50; 
	
	cView.frame = frame;
	
	CGRect textFrame = m.frame;
	textFrame.origin.x += -sin((motion.attitude.roll-oldRotation.roll))*50; 
	textFrame.origin.y += -sin((motion.attitude.pitch-oldRotation.pitch))*50; 
	m.frame = textFrame;
	
	[UIView commitAnimations];*/
	
	
	//[self stopDetectingMotion];
	
	
}

-(void)initLocationManager{
	Marker * messnerMarker = [Marker initMarkerWithTitle:@"MMM" latitude:46.48 longitude:11.30546 altitude:0.0 url:@"de.wikipedia.org/wiki/Messner_Mountain_Museum_Firmian"];
	
	cView = [[Circle alloc] initWithFrame:CGRectMake(50, 100, 25, 25)];
	//[window addSubview:cView];
	//[cView release];
	m = [[MarkerObject alloc]initWithFrame:CGRectMake(100, 200, 60, 60)];
	//m.circle = cView;;
	messnerMarker.markerView = m;
	m.text = messnerMarker.title;
	[_window addSubview:m];
	//[cView release];
	//[m release];
	//[window makeKeyAndVisible];
	
	CLLocationManager* theManager =  [[[CLLocationManager alloc] init]autorelease];
	self.locManager = theManager;
	self.locManager.delegate = self;
	self.locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	if( self.locManager.locationServicesEnabled && self.locManager.headingAvailable) {
		//[locManager startUpdatingLocation];
		self.locManager.headingOrientation;
		self.locManager.headingFilter = 3;
		[self.locManager startUpdatingHeading];
		currentHeading = self.locManager.heading.trueHeading;
		//NSLog(@"heading: %f",self.locManager.heading.trueHeading);
	} else {
		NSLog(@"Can't report heading");
	}
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
	NSLog(@"data received");
	//[self printRotationMatrix];
	//[self printprintRoationMatrix:rot];
	/*rotMatrix[0]=rot.m11; rotMatrix[1]=rot.m21; rotMatrix[2]=rot.m31;  rotMatrix[3]=0;
	rotMatrix[4]=rot.m12; rotMatrix[5]=rot.m22; rotMatrix[6]=rot.m32;  rotMatrix[7]=0;
	rotMatrix[8]=rot.m13; rotMatrix[9]=rot.m23; rotMatrix[10]=rot.m33; rotMatrix[11]=0;
	rotMatrix[12]=0;      rotMatrix[13]=0;      rotMatrix[14]=0;       rotMatrix[15]=1;*/
}

-(void) printRoationMatrix{//: (CMRotationMatrix) matrix{
	//NSLog(@" %f   %f   %f  ||| %f   %f   %f |||  %f   %f    %f", matrix.m11,matrix.m21, matrix.m13, matrix.m21, matrix.m22, matrix.m23, matrix.m31, matrix.m32, matrix.m33);
	NSLog(@"data received");
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

CGFloat DegreesToRadians(CGFloat degrees)
{
	return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
	return radians * 180 / M_PI;
};

#pragma mark -
#pragma mark CLLocationDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	//newHeading.trueHeading
	//NSLog(@"Heading: %f", newHeading.trueHeading);
	/*[UIView beginAnimations:@"MyAnimation" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:2.0]; // 5 seconds
	
	CGRect frame = cView.frame;
	frame.origin.x += -sinf((currentHeading-manager.heading.trueHeading))*50; // Move view down 100 pixels
	cView.frame = frame;
	
	CGRect textFrame = m.frame;
	textFrame.origin.x += -sinf((currentHeading-manager.heading.trueHeading))*50;
	m.frame = textFrame;
	
	[UIView commitAnimations];*/
	currentHeading = manager.heading.trueHeading;
	
}


@end
