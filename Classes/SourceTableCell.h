//
//  SourceTableCell.h
//  Mixare
//
//  Created by jakob on 05.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SourceTableCell : UITableViewCell {
	UILabel * _sourceLabel;
	UIImageView * _sourceLogoView;
	UISwitch * _sourceSwitch;

}
@property (nonatomic, retain) IBOutlet UILabel * sourceLabel;
@property (nonatomic, retain) IBOutlet UISwitch * sourceSwitch;
@property (nonatomic, retain) IBOutlet UIImageView * sourceLogoView;

@end
