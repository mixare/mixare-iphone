//
//  SourceViewController.h
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SourceViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *_dataSourceArray;
}
@property (nonatomic, retain) NSArray *dataSourceArray;
@end
