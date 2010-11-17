//
//  WebViewController.h
//  Mixare
//
//  Created by jakob on 12.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
	NSString * _url;
}
@property (nonatomic, retain) NSString * url;
@end
