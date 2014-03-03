//
//  CMDoorbellListViewController.h
//  covrme
//
//  Created by Anthony Wong on 2014-03-03.
//
//

#import <UIKit/UIKit.h>

@interface CMDoorbellListViewController : UIViewController <
    UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
>

@property (nonatomic, strong) NSFetchedResultsController *frc;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
