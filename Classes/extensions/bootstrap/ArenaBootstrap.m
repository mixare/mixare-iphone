//
//  ArenaBootstrap.m
//  Mixare
//
//  Created by Aswin Ly on 10-01-13.
//  Copyright (c) 2013 Peer GmbH. All rights reserved.
//

#import "ArenaBootstrap.h"

@interface ArenaBootstrap ()

@end

@implementation ArenaBootstrap

@synthesize reUseArenaButton, scanButton;

- (id)init {
    self = [super initWithNibName:@"ArenaBootstrap" bundle:nil];
    if (self != nil) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [scanButton addTarget:self action:@selector(scan) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [reUseArenaButton addTarget:self action:@selector(reuse) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    DataSource *checkSource = [[mainClass _dataSourceManager] getDataSourceByTitle:@"Arena"];
    if (checkSource == nil) {
        [self enableButton:NO button:reUseArenaButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)run:(id<StartMainDelegate>)delegate {
    mainClass = delegate;
    [mainClass setToggleMenuButton:YES];
    [mainClass setPluginDelegate:self];
	[mainClass window].rootViewController = self;
    NSLog(@"ARENA loaded");
}

- (void)reuse {
    [mainClass showHud];
    [self performSelectorInBackground:@selector(openAR) withObject:nil];
}

- (void)openAR {
    [mainClass refresh];
    [mainClass openARView];
    [mainClass closeHud];
}

- (void)scan {
    [mainClass showHud];
    [self performSelectorInBackground:@selector(openScan) withObject:nil];
}
- (void)openScan {
    barcode = [[BarcodeInput alloc] init];
    [barcode runInput:self];
    [mainClass closeHud];
}

- (void)setNewData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    NSString *url = [data objectForKey:@"url"];
    if (url == nil || title == nil || [url isEqualToString:@""] || [title isEqualToString:@""] || [url rangeOfString:@"arena"].location == NSNotFound) {
        [self errorPopUp:@"Geen geldige barcode"];
    } else {
        NSLog(@"URL: %@", url);
        NSLog(@"TITLE: %@", title);
        DataSource *checkSource = [[mainClass _dataSourceManager] getDataSourceByTitle:title];
        if (checkSource != nil) {
            [[mainClass _dataSourceManager] deleteDataSource:checkSource];
        }
        [[[mainClass _dataSourceManager] createDataSource:title dataUrl:url] setActivated:YES];
        [self enableButton:YES button:reUseArenaButton];
    }
}

- (void)enableButton:(BOOL)enable button:(UIButton*)button {
    if (enable) {
        button.enabled = YES;
        button.alpha = 1;
    } else {
        button.enabled = NO;
        button.alpha = 0.3;
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

@end
