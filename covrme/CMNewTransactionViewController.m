//
//  CMNewTransactionViewController.m
//  covrme
//
//  Created by Anthony Wong on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CMNewTransactionViewController.h"

@implementation CMNewTransactionViewController
@synthesize whoTextField = _whoTextField;
@synthesize amountTextField = _amountTextField;
@synthesize descTextField = _descTextField;
@synthesize chargeButton = _chargeButton;
@synthesize cancelButton = _cancelButton;
@synthesize tapGesture = _tapGesture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(dismissKeyboard)];
    self.tapGesture.delegate = self;
    
}

- (void)viewDidUnload
{
    [self setWhoTextField:nil];
    [self setAmountTextField:nil];
    [self setDescTextField:nil];
    [self setChargeButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonPressed:(id)sender
{    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)chargeButtonPressed:(id)sender {
}

#pragma mark - Tap Gesture
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Gesture Recognizer Delegates
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ( ((touch.view == self.cancelButton) || (touch.view == self.chargeButton)) && (gestureRecognizer == self.tapGesture)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{    
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

@end
