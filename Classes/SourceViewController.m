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
				//[cell.sourceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
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
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}else if(indexPath.row == 2){
			[cell.sourceLogoView  setImage:[UIImage imageNamed:@"buzz_logo.png"]];
		}
	}else{
		
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//static NSString * CellIdentifier = @"SourceCell";
	SourceTableCell *cell =  (SourceTableCell *) [tableView cellForRowAtIndexPath:indexPath];
	if(cell != nil){
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			[[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:cell.sourceLabel.text];
		}else{
			cell.accessoryType = UITableViewCellAccessoryNone;
			[[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:cell.sourceLabel.text];
		}
	}else NSLog(@"NOT WORKING");

}

@end

