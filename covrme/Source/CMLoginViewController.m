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

@interface CMLoginViewController ()

@end

@implementation CMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self registerForKeyboardNotifications];
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

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    UIScrollView *this = (UIScrollView *)self.view;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    this.contentInset = contentInsets;
    this.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
        [this setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIScrollView *this = (UIScrollView *)self.view;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    this.contentInset = contentInsets;
    this.scrollIndicatorInsets = contentInsets;
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
         
         [self dismissViewControllerAnimated:YES completion:nil];
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

