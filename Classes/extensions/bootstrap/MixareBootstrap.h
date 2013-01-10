//
//  MixareBootstrap.h
//  Mixare
//
//  Created by Aswin Ly on 10-01-13.
//  Copyright (c) 2013 Peer GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartMain.h"
#import "SetDataSource.h"
#import "PluginEntryPoint.h"
#import "BarcodeInput.h"

@interface MixareBootstrap : UIViewController<PluginEntryPoint, SetDataSource> {
    id<StartMain> mainClass;
    IBOutlet UIButton *scanButton;
    IBOutlet UIButton *reUseArenaButton;
    BarcodeInput *barcode;
}

@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UIButton *reUseArenaButton;

@end
