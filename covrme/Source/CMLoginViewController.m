//
//  CMLoginViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-28.
//
//

#import "CMLoginViewController.h"

@interface CMLoginViewController ()

@end

@implementation CMLoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTouched:(id)sender
{
    
}

- (IBAction)registerTouched:(id)sender
{
    
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    
    if (textField == self.passwordTextField) {
        [self.passwordTextField endEditing:YES];
        [self registerTouched:self.passwordTextField];
    }
    
    return YES;
}

@end

