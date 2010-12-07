//
//  NotificationViewController.h
//  Mixare
//
//  Created by Obkircher Jakob on 06.12.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NotificationViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *indicator;
}
-(void)start;
-(void)stop;
@end
