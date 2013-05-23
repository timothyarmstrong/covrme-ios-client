//
//  CMNewTransactionViewController.h
//  covrme
//
//  Created by Anthony Wong on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMNewTransactionViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *whoTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) UITapGestureRecognizer* tapGesture;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)chargeButtonPressed:(id)sender;

@end
