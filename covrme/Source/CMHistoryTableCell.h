//
//  CMHistoryTableCell.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-29.
//
//

#import <UIKit/UIKit.h>

@interface CMHistoryTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)configureWithDingDong:(NSDictionary *)dingDong;

@end
