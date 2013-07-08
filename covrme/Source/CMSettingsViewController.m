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
        case 3:
            settingsCell.textLabel.text = @"Add a doorbell";
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

- (void)promptToAddDoorbellID
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscribe to a Doorbell"
                                                    message:@"Please enter the ID of the Doorbell you wish to subscribe to"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"Your custom response";
    
    [alert show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Subscribe to a Doorbell"]) {
        if (buttonIndex > 0) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *text = textField.text;
            
            if (text.length) {
                [[CMAPIClient sharedClient]
                 registerUserToDoorbellID:text
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                     message:@"Succesfully subscribed to doorbell"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                     
                     [alert show];
                 }
                 failure:^(NSHTTPURLResponse *response, NSError *error) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                     message:@"Something went wrong!"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                     
                     [alert show];
                 }];
            }
            
        }
    }

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
    } else if (indexPath.row == 3) {
        [self promptToAddDoorbellID];
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
            return 4;
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
