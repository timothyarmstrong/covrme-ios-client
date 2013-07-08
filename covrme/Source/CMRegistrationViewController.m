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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[CMAPIClient sharedClient]
     signupUserWithName:self.nameTextField.text
     email:self.emailTextField.text
     password:self.passwordTextField.text
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *responseDict = (NSDictionary *)responseObject;
         
         NSString *name = [responseDict valueForKey:@"name"];
         NSString *email = [responseDict valueForKey:@"email"];
         NSString *userID = [[responseDict valueForKey:@"Id"] stringValue];
         
         if (name && email) {
             [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"name"];
             [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
             [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"userID"];
             
             // Get AuthToken
             [[CMAPIClient sharedClient]
              getAuthTokenWithEmail:self.emailTextField.text
              password:self.passwordTextField.text
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [[NSUserDefaults standardUserDefaults]
                   setValue:[responseObject valueForKey:@"token"]
                   forKey:@"token"];
                  
                  // Register PushToken
                  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                  [delegate registerPushTokenWithServer];
                  
                  [self dismissViewControllerAnimated:YES completion:nil];
              } failure:^(NSHTTPURLResponse *response, NSError *error) {
                  [self showErrorAlert];
              }];
             

             
         } else {
             [self showErrorAlert];
         }
         
     } failure:^(NSHTTPURLResponse *response, NSError *error) {
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
