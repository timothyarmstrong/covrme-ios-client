//
//  CMRegistrationViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-04.
//
//

#import "CMRegistrationViewController.h"
#import "CMAPIClient.h"
#import "AppDelegate.h"

@interface CMRegistrationViewController ()

@end

@implementation CMRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Register";
	// Do any additional setup after loading the view.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)registerTouched:(id)sender
{
    [SVProgressHUD showWithStatus:@"Registering..."
                         maskType:SVProgressHUDMaskTypeBlack];
    
    [[CMAPIClient sharedClient]
     signupUserWithName:self.nameTextField.text
     email:self.emailTextField.text
     password:self.passwordTextField.text
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *responseDict = (NSDictionary *)responseObject;
         
         NSString *name = [responseDict valueForKey:@"name"];
         NSString *email = [responseDict valueForKey:@"email"];
         NSString *userID = [[responseDict valueForKey:@"id"] stringValue];
         
         if (name && email) {
             [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
             [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"userID"];
             
             // Get AuthToken
             [[CMAPIClient sharedClient]
              getAuthTokenWithEmail:self.emailTextField.text
              password:self.passwordTextField.text
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [SVProgressHUD dismiss];
                  
                  [[NSUserDefaults standardUserDefaults]
                   setValue:[responseObject valueForKey:@"token"]
                   forKey:@"token"];
                  
                  // Register PushToken
                  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                  [delegate registerPushTokenWithServer];
                  
                  [self dismissViewControllerAnimated:YES completion:nil];
              } failure:^(NSHTTPURLResponse *response, NSError *error) {
                  [SVProgressHUD dismiss];
                  [self showErrorAlert];
              }];
         } else {
             [SVProgressHUD dismiss];
             [self showErrorAlert];
         }
     } failure:^(NSHTTPURLResponse *response, NSError *error) {
         [SVProgressHUD dismiss];
         [self showErrorAlert];
     }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    
    if (textField == self.passwordAgainTextField) {
        [self.passwordAgainTextField endEditing:YES];
        [self registerTouched:self.passwordAgainTextField];
    }
    
    return YES;
}

@end
