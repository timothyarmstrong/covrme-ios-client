//
//  CMHistoryListViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-05-18.
//
//

#import <UIKit/UIKit.h>
#import "CMDoorbell.h"

@interface CMHistoryListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dingDongs;
@property (nonatomic, strong) CMDoorbell *doorbell;

- (id)initWithDoorbell:(CMDoorbell *)doorbell;
@end
