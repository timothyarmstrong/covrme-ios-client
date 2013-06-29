//
//  CMFrontDoorViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-18.
//
//

#import <UIKit/UIKit.h>

@interface CMFrontDoorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *picture;
- (IBAction)sendCustomTouched:(id)sender;
@end
