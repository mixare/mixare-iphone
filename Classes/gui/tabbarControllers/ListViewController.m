/*
 * Copyright (C) 2010- Peer internet solutions
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
 * this program. If not, see <http://www.gnu.org/licenses/>
 */

#import "ListViewController.h"
#import "WebViewController.h"
#import "Position.h"
#import "Resources.h"

@implementation ListViewController
@synthesize downloadManager;

/***
 *
 *  PULL TO REDOWNLOAD LAST DOWNLOADED DATA
 *
 ***/
- (void)refresh {
    [downloadManager redownload];
    [self refresh:dataSources];
    [self stopLoading];
}

/***
 *
 *  RENEW TABLE VIEW WITH ACTIVE SOURCES
 *
 ***/
- (void)refresh:(NSMutableArray*)datas {
    dataSources = datas;
    [dataSourceArray removeAllObjects];
    if (dataSources != nil) {
        for (DataSource *data in dataSources) {
            [self convertPositionsToListItems:data];
        }
    }
    [self.tableView reloadData];
}

- (void)convertPositionsToListItems:(DataSource*)data {
    if (dataSourceArray == nil) {
        dataSourceArray = [[NSMutableArray alloc] init];
    }
    for (Position *pos in data.positions) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:pos.image forKey:@"image"];
        [dic setValue:pos.title forKey:@"title"];
        [dic setValue:pos.summary forKey:@"sum"];
        [dic setValue:pos.url forKey:@"url"];
        [dataSourceArray addObject:dic];
    }
}

- (void)viewDidLoad {	
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Poi List", @"Localizable", [[Resources getInstance] bundle], @"");
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
	dataSourceArray = nil;	// this will release and set to nil
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (dataSourceArray != nil) ? [dataSourceArray count] :0;
}

// to determine specific row height for each cell, override this.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ([indexPath row] == 0) ? 60.0 : 60.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
	if (dataSourceArray != nil) {
        //setting the corresponding title for each row .. source array gets set in the app delegate class when downloading new data
		cell.textLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"title"];
		cell.detailTextLabel.text = [dataSourceArray[indexPath.row] valueForKey:@"sum"];
        //adding custom label to each row according to their source
        cell.imageView.image = [dataSourceArray[indexPath.row] valueForKey:@"image"];
    }
	return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate

// the table's selection has changed, switch to that item's UIViewController -> opens the webpage of the item/poi
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"in select row");
	WebViewController *targetViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[[Resources getInstance] bundle]];
    targetViewController.url = [dataSourceArray[indexPath.row] valueForKey:@"url"];
	[[self navigationController] pushViewController:targetViewController animated:YES];
}


@end
