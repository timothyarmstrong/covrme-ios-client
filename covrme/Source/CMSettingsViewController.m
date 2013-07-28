//
//  CMSettingsViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-18.
//
//

#import "CMSettingsViewController.h"
#import "CMSettingsTableCell.h"
#import "CMSettingsSwitchedTableCell.h"
#import "CMCustomResponsesViewController.h"
#import "CMAPIClient.h"
#import "CMDoorbellManagementViewController.h"
#import "CMTonesViewController.h"

@interface CMSettingsViewController ()

@end

@implementation CMSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title
                                                        image:[UIImage imageNamed:@"settings"]
                                                          tag:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CMSettingsTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CMSettingsTableCell"];
    
    nib = [UINib nibWithNibName:@"CMSettingsSwitchedTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CMSettingsSwitchedTableCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path
{
    CMSettingsTableCell *settingsCell = (CMSettingsTableCell *) cell;
    
    NSDictionary *currentTone =
    [[NSUserDefaults standardUserDefaults] valueForKey:@"pushtone"];
    
    switch (path.row) {
        case 0:
            settingsCell.textLabel.text = @"Ringtone";
            settingsCell.subTextLabel.text = currentTone[@"name"];
            break;
        case 1:
            settingsCell.textLabel.text = @"Custom Responses";
            settingsCell.subTextLabel.text = @"";
            break;
        case 2:
            settingsCell.textLabel.text = @"Add a doorbell";
            settingsCell.subTextLabel.text = @"";
            break;
        default:
            settingsCell.textLabel.text = @"Set me up!";
            break;
    }
}

- (void)launchTones
{
    CMTonesViewController *tonesVC =
        [[CMTonesViewController alloc] initWithNibName:@"CMTonesViewController"
                                                bundle:nil];
    
    [self.navigationController pushViewController:tonesVC animated:YES];
}

- (void)launchCustomResponses
{
    CMCustomResponsesViewController *responsesVC =
        [[CMCustomResponsesViewController alloc]
            initWithNibName:@"CMCustomResponsesViewController"
                     bundle:nil];
    
    [self.navigationController pushViewController:responsesVC animated:YES];
    
}

- (void)launchDoorbellManagement
{
    CMDoorbellManagementViewController *doorbellsVC =
        [[CMDoorbellManagementViewController alloc]
            initWithNibName:@"CMDoorbellManagementViewController"
                    bundle:nil];
    
    [self.navigationController pushViewController:doorbellsVC
                                         animated:YES];
}



#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self launchTones];
    } else if (indexPath.row == 1) {
        [self launchCustomResponses];
    } else if (indexPath.row == 2) {
        [self launchDoorbellManagement];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"CMSettingsTableCell"];
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Client Settings";
}
@end
