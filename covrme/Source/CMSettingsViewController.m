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
#import "CMLoginViewController.h"
#import "CMDoorbell.h"
#import "CMCustomResponse.h"

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
    
    // Regular Section
    if (path.section == 0) {
        settingsCell.backgroundColor = [UIColor whiteColor];
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
                settingsCell.textLabel.text = @"Manage doorbells";
                settingsCell.subTextLabel.text = @"";
                break;
            default:
                settingsCell.textLabel.text = @"Set me up!";
                break;
        }
    } else if (path.section == 1) {
        settingsCell.textLabel.textColor = [UIColor redColor];
        settingsCell.textLabel.text = @"Reset App";
        settingsCell.subTextLabel.text = @"";
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

- (void)resetApp
{
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    
    CMLoginViewController *loginVC =
    [[CMLoginViewController alloc] initWithNibName:@"CMLoginViewController"
                                            bundle:nil];
    
    UINavigationController *loginNavController =
    [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self.tabBarController presentViewController:loginNavController
                                        animated:YES
                                      completion:nil];
    
    self.tabBarController.selectedIndex = 1;

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [CMDoorbell truncateAllInContext:localContext];
        [CMCustomResponse truncateAllInContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"App Reset"
                                   message:@"The application has been reset, you will need to restart the application and relogin."
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [resetAlert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self launchTones];
        } else if (indexPath.row == 1) {
            [self launchCustomResponses];
        } else if (indexPath.row == 2) {
            [self launchDoorbellManagement];
        }
    } else if (indexPath.section == 1) {
        [self resetApp];
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
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Client Settings";
    } else {
        return @"";
    }
}
@end
