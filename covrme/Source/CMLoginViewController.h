//
//  CMLoginViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-28.
//
//

#import <UIKit/UIKit.h>

@interface CMLoginViewController : UIViewController

@property (nonatomic, weak) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginTouched:(id)sender;
- (IBAction)registerTouched:(id)sender;

@end
