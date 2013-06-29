//
//  CMCustomResponsesViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-29.
//
//

#import <UIKit/UIKit.h>

@interface CMCustomResponsesViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
- (IBAction)addTouched:(id)sender;

@end
