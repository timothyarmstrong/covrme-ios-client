//
//  CMHistoryListViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-05-18.
//
//

#import "CMHistoryListViewController.h"
#import "UIImageView+WebCache.h"
#import "CMAPIClient.h"
#import "CMHistoryTableCell.h"
#import "CMHistoryDetailViewController.h"

@interface CMHistoryListViewController ()

@end

@implementation CMHistoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"History";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CMHistoryTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CMHistoryTableCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    [[CMAPIClient sharedClient] getHistoryWithDoorbellID:@"65432353"
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     self.dingDongs = (NSArray *) responseObject;
                                                     [self.tableView reloadData];
                                                     [SVProgressHUD dismiss];
                                                 } failure:^(NSHTTPURLResponse *response, NSError *error) {
                                                     [SVProgressHUD dismiss];
                                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launchHistoryWithDoorbellID:(NSString *)doorbellID visitorID:(NSString *)visitorID
{
    CMHistoryDetailViewController *detailVC =
        [[CMHistoryDetailViewController alloc]
             initWithDoorbellID:doorbellID visitorID:visitorID];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewMethods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dingDong = [self.dingDongs objectAtIndex:indexPath.row];
    
    [self launchHistoryWithDoorbellID:@"65432353" visitorID:dingDong[@"id"]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CMHistoryTableCell *cell = (CMHistoryTableCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CMHistoryTableCell"];
    NSDictionary *dingDong = [self.dingDongs objectAtIndex:indexPath.row];
    
    [cell configureWithDingDong:dingDong];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dingDongs count];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
@end
