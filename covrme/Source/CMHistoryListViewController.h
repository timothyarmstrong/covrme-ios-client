//
//  CMHistoryListViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-05-18.
//
//

#import <UIKit/UIKit.h>

@interface CMHistoryListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
