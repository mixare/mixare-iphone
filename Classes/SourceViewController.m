//
//  SourceViewController.m
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SourceViewController.h"
#import "SourceTableCell.h"
//Cons

#define kTextFieldWidth	180.0
#define kViewTag				1
#define kLeftMargin				100.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			11.0

#define kTextFieldHeight		30.0
static NSString *kSectionTitleKey = @"sectionTitleKey";


@implementation SourceViewController
@synthesize dataSourceArray; 

- (void)dealloc
{	
	//dealloc mem
	
	[dataSourceArray release];	
	[super dealloc];
}



- (void)viewDidLoad{	
    [super viewDidLoad];
	dataSourceArray = [[NSArray alloc]initWithObjects:@"Wikipedia",@"Twitter",@"Buzz",nil];
}


// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	// release the controls and set them nil in case they were ever created
	// note: we can't use "self.xxx = nil" since they are read only properties
	//
	self.dataSourceArray = nil;	// this will release and set to nil
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [dataSourceArray count] ;
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 62.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString * CellIdentifier = @"SourceCell";
	SourceTableCell *cell =  (SourceTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil){
		NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SourceCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell = (SourceTableCell *) currentObject;
				break;
			}
		}
	}
	
	
	if(dataSourceArray != nil){
		cell.sourceLabel.text = [dataSourceArray objectAtIndex:indexPath.row];
		if(indexPath.row == 1){
			[cell.sourceLogoView  setImage:[UIImage imageNamed:@"twitter_logo.png"]];
		}else if(indexPath.row == 0){
			[cell.sourceLogoView  setImage:[UIImage imageNamed:@"wikipedia_logo.png"]];
		}else if(indexPath.row == 2){
			[cell.sourceLogoView  setImage:[UIImage imageNamed:@"buzz_logo.png"]];
		}
	}else{
		
	}
	return cell;
}



@end

