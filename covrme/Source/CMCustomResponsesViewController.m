//
//  CMCustomResponsesViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-29.
//
//

#import "CMCustomResponsesViewController.h"

@interface CMCustomResponsesViewController ()

@end

@implementation CMCustomResponsesViewController

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
    self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTouched:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add a response"
                                                    message:@"Please enter the custom response you wish to send"
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
    if (buttonIndex > 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *text = textField.text;
        
        if (text.length) {
            NSLog(@"New custom response: %@", text);
        }

    }
}

@end
