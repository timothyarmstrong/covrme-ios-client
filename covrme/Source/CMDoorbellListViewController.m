//
//  CMDoorbellListViewController.m
//  covrme
//
//  Created by Anthony Wong on 2014-03-03.
//
//

#import "CMDoorbellListViewController.h"
#import "CMDoorbell.h"
#import "CMHistoryListViewController.h"

@interface CMDoorbellListViewController ()

@end

@implementation CMDoorbellListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"History";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.frc.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.frc = [CMDoorbell fetchAllGroupedBy:nil
                               withPredicate:nil
                                    sortedBy:@"addedDate"
                                   ascending:YES];
    
    if ([self.frc fetchedObjects].count == 1) {
        [self openHistoryListForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                 animated:NO];
    }
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openHistoryListForIndexPath:(NSIndexPath *)indexPath
                           animated:(BOOL)animated
{
    CMDoorbell *doorbell = [self.frc.fetchedObjects objectAtIndex:indexPath.row];
    
    
    CMHistoryListViewController *historyListVC = [[CMHistoryListViewController alloc] initWithDoorbell:doorbell];
    
    if (self.frc.fetchedObjects.count == 1) {
        historyListVC.navigationItem.hidesBackButton = YES;
    }
    
    [self.navigationController pushViewController:historyListVC animated:animated];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self openHistoryListForIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CMCustomResponseTableCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"CMCustomResponseTableCell"];
    }
    
    CMDoorbell *doorbell = [self.frc.fetchedObjects objectAtIndex:indexPath.row];
    
    
    if (doorbell.name) {
        cell.textLabel.text = doorbell.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", doorbell.doorbellID];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", doorbell.doorbellID];
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.frc.fetchedObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - NSFetchedResultsController Delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}




@end
