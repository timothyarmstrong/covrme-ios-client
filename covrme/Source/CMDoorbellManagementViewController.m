//
//  CMDoorbellManagementViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import "CMAPIClient.h"
#import "CMDoorbellManagementViewController.h"
#import "CMDoorbell.h"
#import "AppDelegate.h"

@interface CMDoorbellManagementViewController ()

@end

@implementation CMDoorbellManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.addBarItem;
    
    self.frc = [CMDoorbell fetchAllGroupedBy:nil
                               withPredicate:nil
                                    sortedBy:@"addedDate"
                                   ascending:YES];
    self.frc.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Something went wrong deleting.."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark - UITableViewMethods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMDoorbell *doorbell =
        [self.frc.fetchedObjects objectAtIndex:[indexPath row]];
    
    [SVProgressHUD showWithStatus:@"Deleting..."
                         maskType:SVProgressHUDMaskTypeClear];
    
    [[CMAPIClient sharedClient] deleteDoorbellID:[NSString stringWithFormat:@"%@", doorbell.doorbellID]
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [SVProgressHUD dismiss];
                                             [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                                 CMDoorbell *localDoorbell = [doorbell inContext:localContext];
                                                 
                                                 [localDoorbell deleteEntity];
                                             }];
                                         } failure:^(NSHTTPURLResponse *response, NSError *error) {
                                             [SVProgressHUD dismiss];
                                             [self showErrorAlert];
                                         }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

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

#pragma mark = IBActions
- (IBAction)addItemTouched:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register a Doorbell"
                                                    message:@"Please enter ID of the doorbell you wish to subscribe to"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"(ex: DXOL-LQ0K-A4KR-A45X)";
    
    [alert show];
}

#pragma mark - NSFetchedResultsController Delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate reconfigureTabBarController];
    
    [self.tableView reloadData];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Register a Doorbell"]) {
        if (buttonIndex > 0) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *text = [[textField.text uppercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if (text.length) {
                
                self.pendingDoorbellID = text;
                
                if ([CMDoorbell findByAttribute:@"doorbellID" withValue:text].count) {
                    return;
                }
                
                [[CMAPIClient sharedClient]
                 registerUserToDoorbellID:text
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *doorbellDict = responseObject[@"doorbell"];
                     
                     NSString *name = doorbellDict[@"name"];
                     
                     [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                         CMDoorbell* doorbell = [CMDoorbell createInContext:localContext];
                         
                         doorbell.doorbellID = self.pendingDoorbellID;
                         self.pendingDoorbellID = nil;
                         
                         doorbell.addedDate = [NSDate date];
                         
                         if (name && name.length) {
                             doorbell.name = name;
                         } else {
                             doorbell.name = nil;
                         }
                     } completion:^(BOOL success, NSError *error) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kDoorbellAddedNotification"
                                                                             object:nil];
                        
                     }];
                     
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


@end
