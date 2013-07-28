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
    NSString *thumbnail = [NSString stringWithFormat:@"%@=s%@", [dingDong valueForKey:@"photo_thumbnail_url"], @"48"];
    NSURL *url = [NSURL URLWithString:thumbnail];
    
    [self.pictureView setImageWithURL:url
                     placeholderImage:[UIImage imageNamed:@"prof_thumb_placeholder"]];
    
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureView.clipsToBounds = YES;

    self.typeLabel.text = [dingDong valueForKey:@"description"];
    

    
    // RFC3339 date formatting
    NSString *timeStamp = [dingDong valueForKey:@"when"];
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
