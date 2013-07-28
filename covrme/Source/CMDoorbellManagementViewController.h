//
//  CMDoorbellManagementViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import <UIKit/UIKit.h>

@interface CMDoorbellManagementViewController : UIViewController
    <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,
    NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSString *pendingDoorbellID;
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarItem;

- (IBAction)addItemTouched:(id)sender;

@end
