//
//  CMHistoryDetailViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-28.
//
//

#import <UIKit/UIKit.h>

@interface CMHistoryDetailViewController : UIViewController

@property (nonatomic, copy) NSString *doorbellID;
@property (nonatomic, copy) NSString *visitorID;

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *statusString;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithDoorbellID:(NSString *)doorbellID visitorID:(NSString *)visitorID;

@end
