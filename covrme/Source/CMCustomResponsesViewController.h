//
//  CMCustomResponsesViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-29.
//
//

#import <UIKit/UIKit.h>
#import "CMFrontDoorViewController.h"

@interface CMCustomResponsesViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic) NSFetchedResultsController *frc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<DoorbellResponderDelegate> responderDelegate;

- (IBAction)addTouched:(id)sender;

@end
