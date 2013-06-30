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

@interface CMSettingsViewController ()

@end

@implementation CMSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path
{
    CMSettingsSwitchedTableCell *switchedCell = (CMSettingsSwitchedTableCell *) cell;
    CMSettingsTableCell *settingsCell = (CMSettingsTableCell *) cell;
    
    switch (path.row) {
        case 0:
            switchedCell.textLabel.text = @"Quiet Mode";
            break;
        case 1:
            settingsCell.textLabel.text = @"Ringtone";
            break;
        case 2:
            settingsCell.textLabel.text = @"Custom Responses";
            settingsCell.subTextLabel.text = @"";
            break;
        default:
            settingsCell.textLabel.text = @"Set me up!";
            break;
    }
}

- (void)launchCustomResponses
{
    CMCustomResponsesViewController *responsesVC =
    [[CMCustomResponsesViewController alloc] initWithNibName:@"CMCustomResponsesViewController"
                                                      bundle:nil];
    
    [self.navigationController pushViewController:responsesVC animated:YES];
    
}
#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        [self launchCustomResponses];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CMSettingsSwitchedTableCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CMSettingsTableCell"];
    }
    
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
