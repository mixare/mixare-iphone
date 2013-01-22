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

#import "SourceViewController.h"
#import "SourceTableCell.h"
#import "Resources.h"
#import "PluginLoader.h"
#import "DataInput.h"

@implementation SourceViewController
@synthesize dataSourceArray, downloadManager;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/***
 *
 *  PULL TO REDOWNLOAD LAST DOWNLOADED DATA
 *
 ***/
- (void)refresh {
    [downloadManager redownload];
    [self refresh:dataSourceManager];
    [self stopLoading];
}

/***
 *
 *  RENEW TABLE VIEW WITH ACTIVE SOURCES
 *
 ***/
- (void)refresh:(DataSourceManager*)sourceManager {
    dataSourceManager = sourceManager;
    if (dataSourceArray == nil) {
        dataSourceArray = [[NSMutableArray alloc] init];
    }
    [dataSourceArray removeAllObjects];
    for (DataSource* data in dataSourceManager.dataSources) {
        [dataSourceArray addObject:data.title];
        NSLog(@"%@", data.title);
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Sources", nil);
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource)];
    self.navigationItem.rightBarButtonItem = addButton;
    NSMutableArray *availablePlugins = [[PluginLoader getInstance] getPluginsFromClassName:@"DataInput"];
    if ([availablePlugins count] == 0) {
        addButton.enabled = NO;
    } 
}

- (void)setNewData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    NSString *url = [data objectForKey:@"url"];
    if (url == nil || title == nil || [url isEqualToString:@""] || [title isEqualToString:@""]) {
        [self errorPopUp:@"You have to fill all inputs"];
    } else {
        NSLog(@"URL: %@", url);
        NSLog(@"TITLE: %@", title);
        if ([dataSourceManager createDataSource:title dataUrl:url] != nil) {
            [dataSourceArray addObject:title];
        } else {
            [self errorPopUp:@"Added title already exists"];
        }
    }
    [self.tableView reloadData];
}

/***
 *
 *  Open an alert dialog to insert a custom data source by link
 *
 ***/
- (void)addSource {
    NSMutableArray *availablePlugins = [[PluginLoader getInstance] getPluginsFromClassName:@"DataInput"];
    if ([availablePlugins count] == 0) {
        [self errorPopUp:@"No input possibility found"];
    } else if ([availablePlugins count] == 1) {
        id<DataInput> inputPlugin = availablePlugins[0];
        [inputPlugin runInput:self];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Data input", nil)
                                                          message:NSLocalizedString(@"Choose your data input method.", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                otherButtonTitles:nil];
        for (id<DataInput> inputPlugin in availablePlugins) {
            [message addButtonWithTitle:[inputPlugin getTitle]];
        }
        [message show];
    }
}

/***
 *
 *  Response to (void)addSource
 *
 ***/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSMutableArray *availablePlugins = [[PluginLoader getInstance] getPluginsFromClassName:@"DataInput"];
    for (id<DataInput> inputPlugin in availablePlugins) {
        if([title isEqualToString:[inputPlugin getTitle]]) {
            [inputPlugin runInput:self];
        }
    }
}

- (void)errorPopUp:(NSString*)message {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                       message:NSLocalizedString(message, nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                             otherButtonTitles:nil];
    [addAlert show];
}

/***
 *
 *  Called after the view controller's view is released and set to nil.
 *  For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
 *  So release any properties that are loaded in viewDidLoad or can be recreated lazily.
 *
 ***/
- (void)viewDidUnload {
    [super viewDidUnload];
	// release the controls and set them nil in case they were ever created
	// note: we can't use "self.xxx = nil" since they are read only properties
	//
	self.dataSourceArray = nil;	// this will release and set to nil
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSourceArray count];
}

/***
 *
 *  To determine specific row height for each cell, override this.
 *  In this example, each row is determined by its subviews that are embedded.
 *
 ***/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return 55.0;
}

/***
 *
 *  To determine which UITableViewCell to be used on a given row.
 *
 ***/
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *CellIdentifier = @"SourceCell";
	SourceTableCell *cell = (SourceTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[[Resources getInstance] bundle] loadNibNamed:@"SourceCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (SourceTableCell*)currentObject;
				//[cell.sourceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
				break;
			}
		}
	}
	if (dataSourceArray != nil) {
		cell.sourceLabel.text = dataSourceArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].logo != nil) {
			[cell.sourceLogoView setImage:[dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].logo];
		} else {
            [cell.sourceLogoView setImage:[UIImage imageNamed:@"logo_mixare_round.png"]]; 
        }
	} 
    if ([dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].activated) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
	return cell;
}

/***
 *
 *  Select source(s) for view
 *
 ***/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	SourceTableCell *cell = (SourceTableCell*)[tableView cellForRowAtIndexPath:indexPath];
	if (cell != nil) {
		if (cell.accessoryType == UITableViewCellAccessoryNone) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].activated = YES; //ACTIVATE DataSource
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
            [dataSourceManager getDataSourceByTitle:cell.sourceLabel.text].activated = NO; //DEACTIVATE DataSource
		}
	} else NSLog(@"NOT WORKING");

}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    //if user wants to deleta a soucre checkin weather if its a source he added else get restricted
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[dataSourceManager getDataSourceByTitle:dataSourceArray[indexPath.row]] locked]) {
            [self errorPopUp:@"You can only delete your own sources!"];
        } else {
            [dataSourceManager deleteDataSource:[dataSourceManager getDataSourceByTitle:dataSourceArray[indexPath.row]]];
            [dataSourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath {
    return NO;
}
    
@end

