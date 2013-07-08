//
//  CMRegistrationViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-04.
//
//

#import <UIKit/UIKit.h>

@interface CMRegistrationViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

- (IBAction)registerTouched:(id)sender;

@end
