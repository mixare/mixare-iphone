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



@implementation SourceViewController
@synthesize dataSourceArray; 

- (void)dealloc
{	
	//dealloc mem
	
	[dataSourceArray release];	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad{	
    [super viewDidLoad];
    //initialisation of the datasource with the default sources
	dataSourceArray = [[NSMutableArray alloc]initWithObjects:@"Wikipedia",@"Twitter",@"Buzz",nil];
    self.navigationItem.title = NSLocalizedString(@"Sources", nil);
//    NSString * custom_url = [[NSUserDefaults standardUserDefaults]objectForKey:@"extern_url"];
//    NSLog(@"EXTERN URL %@",custom_url);
//    if(custom_url != nil){
//        [dataSourceArray addObject:custom_url];
//    }
}

//called when user is pressing the plsu symbol on the top right of the navigationbar
//open a dialog to insert a custom data source
-(IBAction)addSource{
    UIAlertView *addAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add Source",nil) message:NSLocalizedString(@"\n\n\n Insert your Source address",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    CGRect frame = CGRectMake(0, 20, addAlert.frame.size.width, addAlert.frame.size.height);
    addAlert.frame = frame;
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,40,260,25)];
    addressLabel.font = [UIFont systemFontOfSize:16];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.shadowColor = [UIColor blackColor];
    addressLabel.shadowOffset = CGSizeMake(0,-1);
    addressLabel.textAlignment = UITextAlignmentCenter;
    addressLabel.text = NSLocalizedString(@"Format:www.example.com", nil) ;
    [addAlert addSubview:addressLabel];
    UITextField *addressField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
    addressField.borderStyle = UITextBorderStyleRoundedRect;
    addressField.keyboardAppearance = UIKeyboardAppearanceAlert;
    addressField.delegate = self;
    [addressField becomeFirstResponder];
    [addAlert addSubview:addressField];
    [addAlert show];
    [addAlert release];
    [addressField release];
    [addressLabel release];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    sourceURL = textField.text;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        //User pressed OK button
        [dataSourceArray addObject:sourceURL];
        [self.tableView reloadData];
    }
    
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
	return 55.0;
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
		}else if(indexPath.row > 2 ){
          [cell.sourceLogoView  setImage:[UIImage imageNamed:@"logo_mixare_round.png"]]; 
        }
	}else{
		
	}
    if([[[NSUserDefaults standardUserDefaults] objectForKey:cell.sourceLabel.text] isEqualToString:@"TRUE"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
	return cell;
}

//TODO: keeping track if the user changes sources to not have to download data
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//static NSString * CellIdentifier = @"SourceCell";
	SourceTableCell *cell =  (SourceTableCell *) [tableView cellForRowAtIndexPath:indexPath];
	if(cell != nil){
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			[[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:cell.sourceLabel.text];
            //[[NSUserDefaults standardUserDefaults] setObject:@"CHANGED" forKey:@"changeStatus";
		}else{
			cell.accessoryType = UITableViewCellAccessoryNone;
			[[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:cell.sourceLabel.text];
		}
	}else NSLog(@"NOT WORKING");

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //if user wants to deleta a soucre checkin weather if its a source he added else get restricted
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(indexPath.row >2){
            [dataSourceArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }else{
            UIAlertView *addAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Not Allowed",nil) message:@"You can only delete own sources!" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
            [addAlert show];
            [addAlert release];
        }
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
    
@end

