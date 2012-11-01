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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PullRefreshTableViewController.h"
#import "DataSourceManager.h"
#import "DownloadManager.h"

//ViewController for the source tabbarsection 
@interface SourceViewController : PullRefreshTableViewController<UITextFieldDelegate,UIAlertViewDelegate> {
	NSMutableArray *dataSourceArray;
    IBOutlet UIBarButtonItem *addButton;
    DownloadManager *downloadManager;
    DataSourceManager *dataSourceManager;
    UITextField *textField;
    UITextField *urlField;
}

- (IBAction)addSource;
- (void)refresh:(DataSourceManager*)dataSourceManager;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) DownloadManager *downloadManager;

@end
