//
//  CMLoginViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-28.
//
//

#import "CMLoginViewController.h"
#import "CMAPIClient.h"
#import "AppDelegate.h"
#import "CMRegistrationViewController.h"
#import "CMDoorbell.h"

@interface CMLoginViewController ()

@end

@implementation CMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Login";
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void)showErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Something went wrong trying to register, try again"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)showInvalidLogin
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Invalid usernme / password"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (IBAction)loginTouched:(id)sender
{
    [self.activeField endEditing:YES];
    
    [SVProgressHUD showWithStatus:@"Logging in..."
                         maskType:SVProgressHUDMaskTypeClear];
    [[CMAPIClient sharedClient]
     getAuthTokenWithEmail:self.emailTextField.text
     password:self.passwordTextField.text
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [SVProgressHUD dismiss];
         
         if ([responseObject valueForKey:@"error"]) {
             [self showInvalidLogin];
             return;
         }
         
         [[NSUserDefaults standardUserDefaults]
          setValue:[responseObject valueForKey:@"token"]
          forKey:@"token"];
         
         [[NSUserDefaults standardUserDefaults]
          setValue:[responseObject valueForKey:@"user_id"]
          forKey:@"userID"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         // Register PushToken
         AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         [delegate registerPushTokenWithServer];
         
         // Get existing doorbells
         [[CMAPIClient sharedClient] getRegisteredDoorbellsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSArray *registeredBells = [NSArray arrayWithArray:responseObject];
             
             if (registeredBells && registeredBells.count) {
                 [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                     for (int i = 0; i < registeredBells.count; i++) {
                         NSDictionary *doorbellDict = registeredBells[i];
                         
                         CMDoorbell* doorbell = [CMDoorbell createInContext:localContext];
                         doorbell.doorbellID = doorbellDict[@"id"];
                         doorbell.name = doorbellDict[@"name"];
                         doorbell.addedDate = [NSDate date];
                     }
                 } completion:^(BOOL success, NSError *error) {
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }];
             } else {
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             
         }
                                                               failure:^{
                                                                   [SVProgressHUD dismiss];
                                                                   [self showErrorAlert];
                                                               }];
     } failure:^(NSHTTPURLResponse *response, NSError *error) {
         [SVProgressHUD dismiss];
         [self showErrorAlert];
     }];
}

- (IBAction)registerTouched:(id)sender
{
    CMRegistrationViewController *registrationVC =
    [[CMRegistrationViewController alloc]
     initWithNibName:@"CMRegistrationViewController"
     bundle:nil];
    
    [self.navigationController pushViewController:registrationVC animated:YES];
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    
    if (textField == self.passwordTextField) {
        [self.passwordTextField endEditing:YES];
        [self loginTouched:self.passwordTextField];
    }
    
    return YES;
}

@end

