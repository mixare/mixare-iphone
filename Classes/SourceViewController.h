//
//  SourceViewController.h
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SourceViewController : UITableViewController  {
	NSArray *dataSourceArray;
	int keyboardHeight;	
}

@property (nonatomic, retain) NSArray *dataSourceArray;
@end
