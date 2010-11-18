/* Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/> */

#import "CamViewController.h"
#define CAMERA_TRANSFORM 1.22412
#define GRAD_TO_PIX_VAL_WITH 6.738
#define GRAD_TO_PIX_VAL_LENGTH 7.89
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
	NSLog(@"Distance between mmm and peer : %f",[PhysicalPlace distanceBetweenLong1:11.295437 lat1:46.478766 long2:11.305661 lat2:46.479756]);
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
		CMDeviceMotion *dm = motionManager.deviceMotion;
		referenceAttitude = [dm.attitude retain];
		NSLog(@"ref matrix = [%f, %f, %f]", referenceAttitude.rotationMatrix.m11, referenceAttitude.rotationMatrix.m12,referenceAttitude.rotationMatrix.m13);
		NSLog(@"ref matrix = [%f, %f, %f]", referenceAttitude.rotationMatrix.m21, referenceAttitude.rotationMatrix.m22,referenceAttitude.rotationMatrix.m23);
		NSLog(@"ref matrix = [%f, %f, %f]", referenceAttitude.rotationMatrix.m31, referenceAttitude.rotationMatrix.m32,referenceAttitude.rotationMatrix.m33);
		NSLog(@"---------------------------------------------------------------------------");
		
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
	motionManager.deviceMotionUpdateInterval = 0.25;
	
	NSUInteger historyIndex = 0;
	if (motionManager.isDeviceMotionAvailable) {
		histroy = [[NSMutableArray alloc] initWithCapacity:50];
		changeRoll = 0;
		changePitch= 0;
		oldP = 0;
		oldR = 0;
		isFirstAcces = YES;
		camera = [[[Camera alloc]init]autorelease];
		MixVector * vec = [PhysicalPlace convLocToVecWithLocation:_locManager.location place:messnerMarker.mGeoLoc];
		NSLog(@"VECTOR tis to mmm : x: %f| y: %f| z: %f|", vec.x, vec.y, vec.z); 
		//[vec retain];
		messnerMarker.locationVector = vec;
		[motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
										   withHandler: ^(CMDeviceMotion *motion, NSError *error)
		 {
			 CMAttitude *attitude = motion.attitude;
			 
			 if(isFirstAcces==YES){
				 oldP = attitude.yaw* 180 / M_PI;
				 oldR = attitude.roll* 180 / M_PI;
				 isFirstAcces = NO;
			 }
			 changePitch = oldP - (attitude.yaw* 180 / M_PI);
			 changeRoll = oldR - (attitude.roll* 180 / M_PI);
			 
			 [UIView beginAnimations:@"MyAnimation" context:nil];
			 [UIView setAnimationBeginsFromCurrentState:YES];
			 [UIView setAnimationDuration:0.5]; // 5 seconds
			 
			 CGRect frame = m.frame;
			 frame.origin.x -= changePitch*GRAD_TO_PIX_VAL_LENGTH;
			 frame.origin.y -= changeRoll*GRAD_TO_PIX_VAL_WITH; 
			 
			 m.frame = frame;
			 
			 
			 [UIView commitAnimations];
			 
			 
			 
			 
			 
			 
			 NSLog(@"roll: %f pitch: %f yaw: %f", attitude.roll* 180 / M_PI, attitude.pitch* 180 / M_PI, attitude.yaw* 180 / M_PI);			 
			 NSLog(@"changeR: %f changeP: %f", changeRoll, changePitch);
			 oldR = attitude.roll* 180 / M_PI;
			 oldP = attitude.yaw* 180 / M_PI;
			 
			 
			 CMRotationMatrix rotMatrix = attitude.rotationMatrix;
			 CMRotationMatrix rot2;
			 NSLog(@"rotation matrix = [%f, %f, %f]", rotMatrix.m11, rotMatrix.m12,rotMatrix.m13);
			 NSLog(@"rotation matrix = [%f, %f, %f]", rotMatrix.m21, rotMatrix.m22,rotMatrix.m23);
			 NSLog(@"rotation matrix = [%f, %f, %f]", rotMatrix.m31, rotMatrix.m32,rotMatrix.m33);
			 NSLog(@"---------------------------------------------------------------------------");
			 
			 tempR = [Matrix initMatrixWithA1:rotMatrix.m11 a2:rotMatrix.m21 a3:rotMatrix.m31 b1:rotMatrix.m12 b2:rotMatrix.m22 b3:rotMatrix.m32 c1:rotMatrix.m13 c2:rotMatrix.m23 c3:rotMatrix.m33];
			 finalR = [[Matrix alloc]init];
			 [finalR toIdentity];
			 [finalR prodWithMatrix:m4];
			 [finalR prodWithMatrix:m1];
			 [finalR prodWithMatrix:tempR];
			 [finalR prodWithMatrix:m3];
			 [finalR prodWithMatrix:m2];
			 [finalR invert];
			 
			 [self calcPitchBearingFromRotationMatrix:finalR];
			 [smoothR setToA1:0.0 a2:0.0 a3:0.0 b1:0.0 b2:0.0 b3:0.0 c1:0.0 c2:0.0 c3:0.0];
			 
			 MixVector * mv = [[[MixVector alloc]init]autorelease];
			 mv.x = 0; mv.y= 0; mv.z=0;
			
			 if(messnerMarker != nil){
				 MixVector* temp = [messnerMarker cCMarkerWithOrigPoint:mv rotM:finalR addX:0 addY:0];
				 NSLog(@"pix values: x: %f  y: %f", temp.x, temp.y);
			 }
		}];		
	}
	else {
		NSLog(@"motion not available");
	}
	
}

-(void)calcPitchBearingFromRotationMatrix: (Matrix*) rotationM{
	MixVector * looking = [[MixVector alloc]init];
	[rotationM transpose];
	[looking setVector:[MixVector initWithX:0.0 y:1.0 z:0.0]];
	[looking prodWithVec1:[MixVector initWithX:rotationM.a1 y:rotationM.a2 z:rotationM.a3] vec2:[MixVector initWithX:rotationM.b1 y:rotationM.b2 z:rotationM.b3] vec3:[MixVector initWithX:rotationM.c1 y:rotationM.c2 z:rotationM.c3]];
	float bearing = [self getAngleFromCenter: 0  centerY: 0  postX: looking.x postY: looking.y];
	NSLog(@"BEaring: %f",bearing);
	[rotationM transpose];
	[looking setVector:[MixVector initWithX:0.0 y:1.0 z:0.0]];
	[looking prodWithVec1:[MixVector initWithX:rotationM.a1 y:rotationM.a2 z:rotationM.a3] vec2:[MixVector initWithX:rotationM.b1 y:rotationM.b2 z:rotationM.b3] vec3:[MixVector initWithX:rotationM.c1 y:rotationM.c2 z:rotationM.c3]];
	float pitch = - [self getAngleFromCenter:0.0 centerY:0.0 postX:looking.y postY:looking.z];
	NSLog(@"Pitch: %f", pitch);
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
	messnerMarker = [Marker initMarkerWithTitle:@"MMM" latitude:46.479741 longitude:11.305672 altitude:0.0 url:@"de.wikipedia.org/wiki/Messner_Mountain_Museum_Firmian"];
	[messnerMarker retain];
	//cView = [[Circle alloc] initWithFrame:CGRectMake(50, 100, 25, 25)];
	//[window addSubview:cView];
	//[cView release];
	m = [[MarkerObject alloc]initWithFrame:CGRectMake(100, 200, 60, 60)];
	//m.circle = cView;;
	//messnerMarker.markerView = m;
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
	[messnerMarker release];
}

CGFloat DegreesToRadians(CGFloat degrees)
{
	return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
	return radians * 180 / M_PI;
};

-(float) getAngleFromCenter: (float) centerX centerY: (float) centerY postX: (float) postX postY: (float) postY{
	float tmpv_x = postX - centerX;
	float tmpv_y = postY - centerY;
	float d = sqrtf(tmpv_x * tmpv_x + tmpv_y * tmpv_y);
	float cos = tmpv_x / d;
	float angle = (float) (acosf(cos)* 180 / M_PI);
	
	angle = (tmpv_y < 0) ? angle * -1 : angle;
	
	return angle;
}




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
