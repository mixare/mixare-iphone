//
//  ListViewController.h
//  Mixare
//
//  Created by jakob on 05.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JsonHandler.h"
@interface ListViewController : UITableViewController<UITableViewDelegate>  {
	NSMutableArray *dataSourceArray;
	int keyboardHeight;
	//data
	NSMutableArray * source;
	
}
-(void)initDataSourceWithJSONData;

@property (nonatomic, retain) IBOutlet NSMutableArray *dataSourceArray;
@end
