//
//  CMSettingsViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-18.
//
//

#import <UIKit/UIKit.h>

@interface CMSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
