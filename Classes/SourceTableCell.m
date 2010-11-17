//
//  SourceTableCell.m
//  Mixare
//
//  Created by jakob on 05.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SourceTableCell.h"

@implementation SourceTableCell
@synthesize sourceLabel = _sourceLabel;
//@synthesize sourceSwitch = _sourceSwitch;
@synthesize sourceLogoView = _sourceLogoView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
