//
//  CMFrontDoorViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-18.
//
//

#import <UIKit/UIKit.h>

@protocol DoorbellResponderDelegate <NSObject>

- (void)sendResponse:(NSString *)text;

@end

@interface CMFrontDoorViewController : UIViewController <DoorbellResponderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIView *noOneView;
@property (weak, nonatomic) IBOutlet UIButton *omwButton;
@property (weak, nonatomic) IBOutlet UIButton *notHereButton;
@property (weak, nonatomic) IBOutlet UIButton *sendCustomButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic, strong) NSString* currentVisitorID;
@property (nonatomic, strong) NSString* currentDoorbellID;

@property (nonatomic, strong) NSString *lastDoorbellID;

- (IBAction)sendCustomTouched:(id)sender;
- (IBAction)notHereTouched:(id)sender;
- (IBAction)omwTouched:(id)sender;
@end
