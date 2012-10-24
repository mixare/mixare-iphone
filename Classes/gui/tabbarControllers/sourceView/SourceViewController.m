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
//Cons

#define kTextFieldWidth         180.0
#define kViewTag				1
#define kLeftMargin				100.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			11.0
#define kTextFieldHeight		30.0

@implementation SourceViewController
@synthesize dataSourceArray; 

- (void)dealloc {	
	//dealloc mem
	[dataSourceArray release];	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

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
    //initialisation of the datasource with the default sources
    self.navigationItem.title = NSLocalizedString(@"Sources", nil);
//    NSString * custom_url = [[NSUserDefaults standardUserDefaults]objectForKey:@"extern_url"];
//    NSLog(@"EXTERN URL %@",custom_url);
//    if(custom_url != nil){
//        [dataSourceArray addObject:custom_url];
//    }
}

/***
 *
 *  Open an alert dialog to insert a custom data source by link
 *
 ***/
- (void)addSource {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add Source",nil)
                                                      message:NSLocalizedString(@"Insert your Source address \n\n\n\n\n",nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                            otherButtonTitles:NSLocalizedString(@"OK",nil), nil];

    textField = [[UITextField alloc] init];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleLine;
    textField.frame = CGRectMake(15, 75, 255, 30);
    textField.font = [UIFont fontWithName:@"ArialMT" size:20];
    textField.placeholder = NSLocalizedString(@"Title",nil);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [textField becomeFirstResponder];
    [addAlert addSubview:textField];
    
    urlField = [[UITextField alloc] init];
    [urlField setBackgroundColor:[UIColor whiteColor]];
    urlField.delegate = self;
    urlField.borderStyle = UITextBorderStyleLine;
    urlField.frame = CGRectMake(15, 120, 255, 30);
    urlField.font = [UIFont fontWithName:@"ArialMT" size:20];
    urlField.placeholder = NSLocalizedString(@"Format:www.example.com",nil);
    urlField.textAlignment = NSTextAlignmentCenter;
    urlField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [addAlert addSubview:urlField];
    [addAlert show];
    [addAlert release];
}

/***
 *
 *  Responses of both Alert Dialogs
 *
 ***/
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (urlField.text == nil || textField.text == nil || [urlField.text isEqualToString:@""] || [textField.text isEqualToString:@""]) {
            [self errorPopUp:@"You have to fill all inputs"];
        } else {
            NSLog(@"URL: %@", urlField.text);
            NSLog(@"TITLE: %@", textField.text);
            if ([dataSourceManager getDataSourceByTitle:textField.text] == nil) {
                DataSource *data = [[DataSource alloc] title:textField.text jsonUrl:urlField.text];
                data.activated = NO;
                [dataSourceManager.dataSources addObject:data];
                [dataSourceManager writeDataSources];
                [dataSourceArray addObject:textField.text];
            } else {
                [self errorPopUp:@"Added title already exists"];
            }
        }
        [self.tableView reloadData];
        [urlField release];
        [textField release];
    }
}

- (void)errorPopUp:(NSString*)message {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                       message:NSLocalizedString(message, nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                             otherButtonTitles:nil];
    [addAlert show];
    [addAlert release];
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
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SourceCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (SourceTableCell*)currentObject;
				//[cell.sourceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
				break;
			}
		}
	}
	if (dataSourceArray != nil) {
		cell.sourceLabel.text = [dataSourceArray objectAtIndex:indexPath.row];
		if (indexPath.row == 1) {
			[cell.sourceLogoView setImage:[UIImage imageNamed:@"twitter_logo.png"]];
		} else if(indexPath.row == 0) {
			[cell.sourceLogoView setImage:[UIImage imageNamed:@"wikipedia_logo.png"]];
			//cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else if(indexPath.row > 1 ) {
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
        if (indexPath.row > 1) {
            [dataSourceManager deleteDataSource:[dataSourceManager getDataSourceByTitle:[dataSourceArray objectAtIndex:indexPath.row]]];
            [dataSourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        } else {
            [self errorPopUp:@"You can only delete own sources!"];
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

