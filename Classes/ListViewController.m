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

#import "ListViewController.h"
#import "WebViewController.h"


@implementation ListViewController
@synthesize dataSourceArray= source; 

- (void)dealloc
{	
	//dealloc mem
	
	[dataSourceArray release];
	[source release];
	
	[super dealloc];
}



- (void)viewDidLoad{	
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Poi List", nil);
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
	source = nil;
}



#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
	return (source != nil) ? [source count] :0;
}

// to determine specific row height for each cell, override this.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ([indexPath row] == 0) ? 60.0 : 60.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = nil;
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
	if(source != nil){
		cell.textLabel.text = [[source objectAtIndex:indexPath.row]valueForKey:@"title"];
		cell.detailTextLabel.text = [[source objectAtIndex:indexPath.row]valueForKey:@"sum"];
        //adding custom label to each row according to their source
        if([[[source objectAtIndex:indexPath.row]valueForKey:@"source"] isEqualToString:@"WIKIPEDIA"]){
            cell.imageView.image = [UIImage imageNamed:@"wikipedia_logo_small.png"];
        }else if([[[source objectAtIndex:indexPath.row]valueForKey:@"source"] isEqualToString:@"BUZZ"]){
            cell.imageView.image = [UIImage imageNamed:@"buzz_logo_small.png"];
        }else if([[[source objectAtIndex:indexPath.row]valueForKey:@"source"] isEqualToString:@"TWITTER"]){
            cell.imageView.image = [UIImage imageNamed:@"twitter_logo_small.png"];
        }else if([[[source objectAtIndex:indexPath.row]valueForKey:@"source"] isEqualToString:@"MIXARE"]){
            cell.imageView.image = [UIImage imageNamed:@"logo_mixare_round.png"];
        }
    }
	return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"in select row");
	WebViewController *targetViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
    targetViewController.url = [[source objectAtIndex:indexPath.row]valueForKey:@"url"];
	
	[[self navigationController] pushViewController:targetViewController animated:YES];
}

@end
