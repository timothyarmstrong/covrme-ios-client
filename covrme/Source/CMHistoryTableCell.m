//
//  CMHistoryTableCell.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-29.
//
//

#import "CMHistoryTableCell.h"
#import "UIImageView+WebCache.h"

@implementation CMHistoryTableCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
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

- (void)configureWithDingDong:(NSDictionary *)dingDong
{
    [self.pictureView setImageWithURL:[dingDong valueForKey:@"pictureURL"]
                     placeholderImage:[UIImage imageNamed:@"placeholder_48"]];

    self.typeLabel.text = [dingDong valueForKey:@"type"];
    
    NSDate *timeStamp = [dingDong valueForKey:@"timestamp"];
    NSString *formattedString = [NSDateFormatter localizedStringFromDate:timeStamp
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterNoStyle];

    self.dateLabel.text = formattedString;
}

@end
