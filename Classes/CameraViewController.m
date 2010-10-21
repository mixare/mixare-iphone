//
//  FirstViewController.m
//  Mixare
//
//  Created by jakob on 05.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"


@implementation CameraViewController
@synthesize imgPicker;
@synthesize cameraView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)viewWillAppear{
	NSLog(@"in view");
    /* generate the controller */
    imgPicker = [[[UIImagePickerController alloc] init]
           autorelease];
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;  
    imgPicker.showsCameraControls = NO;
	
    /* move the controller, to make the 
     statusbar visible */
    CGRect frame = imgPicker.view.frame;
    frame.origin.y += 30;
    frame.size.height -= 30;
    imgPicker.view.frame = frame;
	
    /* add the view to the window */
    [cameraView addSubview:[imgPicker view]];
	
    /* make sure to change the alpha value 
     of the view */
    //[navigationController.view setAlpha:0.7]
	
    /* add the original view controller */
    // [window addSubview:[navigationController view]];
    //[cameraView makeKeyAndVisible];

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
