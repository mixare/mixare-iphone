//
//  MixareBootstrap.m
//  Mixare
//
//  Created by Aswin Ly on 10-01-13.
//  Copyright (c) 2013 Peer GmbH. All rights reserved.
//

#import "MixareBootstrap.h"
#import "DataSourceManager.h"

@interface MixareBootstrap ()

@end

@implementation MixareBootstrap

@synthesize reUseArenaButton, scanButton;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)run:(id<StartMain>)delegate {
    mainClass = delegate;
    [mainClass setToggleMenu:YES];
    NSLog(@"MIXARE loaded");
    // [mainClass showHud];                    //  Show indicator
	[mainClass mainWindow].rootViewController = self;
}

- (void)reuse {
    [mainClass openARView];
}

- (void)scan {
    barcode = [[BarcodeInput alloc] init];
    [barcode runInput:self];
}

- (void)setNewData:(NSDictionary *)data {
    NSString *title = [data objectForKey:@"title"];
    NSString *url = [data objectForKey:@"url"];
    if (url == nil || title == nil || [url isEqualToString:@""] || [title isEqualToString:@""]) {
        NSLog(@"ERROR");
    } else {
        NSLog(@"URL: %@", url);
        NSLog(@"TITLEZ: %@", title);
        if ([[mainClass _dataSourceManager] createDataSource:title dataUrl:url] == nil) {
            [[mainClass _dataSourceManager] deleteDataSource:[[mainClass _dataSourceManager] getDataSourceByTitle:title]];
            [[mainClass _dataSourceManager] createDataSource:title dataUrl:url];
        }
    }
}


@end
