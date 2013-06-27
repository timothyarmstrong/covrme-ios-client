//
//  CMSettingsTableCell.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-27.
//
//

#import "CMSettingsTableCell.h"

@implementation CMSettingsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
