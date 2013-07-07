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
@property (weak, nonatomic) IBOutlet UIView *noOneView;
- (IBAction)sendCustomTouched:(id)sender;
@end
