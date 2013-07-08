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
    [self.pictureView setImageWithURL:[dingDong valueForKey:@"ThumbnailUrl"]
                     placeholderImage:[UIImage imageNamed:@"prof_thumb_placeholder"]];

    self.typeLabel.text = [dingDong valueForKey:@"Description"];
    

    
    // RFC3339 date formatting
    NSString *timeStamp = [dingDong valueForKey:@"When"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ";
    
    NSDate *date;
    NSError *error;
    [formatter getObjectValue:&date forString:timeStamp range:nil error:&error];
    
    NSString *formattedString = [NSDateFormatter localizedStringFromDate:date
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterNoStyle];

    self.dateLabel.text = formattedString;
}

@end
