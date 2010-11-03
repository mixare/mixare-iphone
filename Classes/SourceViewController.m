//
//  SourceViewController.m
//  Mixare
//
//  Created by jakob on 02.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SourceViewController.h"
#define kViewTag				1
static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kLabelKey = @"labelKey";
static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";

@implementation SourceViewController
@synthesize dataSourceArray = _dataSourceArray;
- (void)dealloc{	
	[_dataSourceArray release];
	[super dealloc];
}



- (void)viewDidLoad{	
    [super viewDidLoad];
	_dataSourceArray = [NSArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:
							 // @"Settings", kSectionTitleKey,
							 @"", kLabelKey,
							 @"Wikipedia", kSourceKey,
							 nil],
							[NSDictionary dictionaryWithObjectsAndKeys:
							 // @"Settings", kSectionTitleKey,
							 @"", kLabelKey,
							 @"Twitter", kSourceKey,
							 nil],
							nil];
	NSLog(@"in sourceview controller");
	//[self.tableView setDelegate:self];
	//[self.tableView setDataSource:self];
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.dataSourceArray = nil;	// this will release and set to nil
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.dataSourceArray objectAtIndex: section] valueForKey:kSectionTitleKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ([indexPath row] == 0) ? 50.0 : 50.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = nil;
	cell.textLabel.text = [[self.dataSourceArray objectAtIndex: indexPath.row] valueForKey:kSourceKey];
	if (indexPath.row==0) {
		cell.image = [UIImage imageNamed:@"wikipedia_logo.png"];
	}else {
		cell.image = [UIImage imageNamed:@"twitter_logo.png"];
	}

	
				
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section ==0) {
		return @"Insert your login information - username and password is the same as in the webpage visittrentino.it";
	}else {
		return @"Offline mode makes no connection to the internet - local data is used. \n 	Save money mode will ask you each time \n for permission when a connection to the internet is made";
	}
	
}

@end
