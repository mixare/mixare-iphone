//
//  MoreViewController.h
//  Mixare
//
//  Created by Obkircher Jakob on 23.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

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
 