//
//  CMFrontDoorViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-18.
//
//

#import <QuartzCore/QuartzCore.h>

#import "CMFrontDoorViewController.h"
#import "CMCustomResponsesViewController.h"
#import "CMAPIClient.h"
#import "UIImageView+WebCache.h"
#import "CMDoorbell.h"
#import "UIColor+Helpers.h"

@interface CMFrontDoorViewController ()

@end

@implementation CMFrontDoorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Front Door";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"detaileddoor"] tag:0];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Methods

- (void)sendResponse:(NSString *)text
{
    
    if (!self.lastDoorbellID) {
        self.lastDoorbellID = self.currentDoorbellID;
    }
    
    [[CMAPIClient sharedClient]
         sendMessageToDoorbellID:self.lastDoorbellID
         withVisitorID:self.currentVisitorID
         withMessage:text
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self showSuccessMessageAlert];
         }
         failure:^(NSHTTPURLResponse *response, NSError *error) {
             [self showFailureMessageAlert];
         }];
}

- (void)showSuccessMessageAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                    message:@"Message Delivered!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)showFailureMessageAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:@"Something went wrong!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)showNoOneView
{
    if (self.noOneView.hidden == NO) {
        return;
    }
    
    self.noOneView.hidden = NO;
    self.noOneView.alpha = 0.f;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.noOneView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         self.noOneView.alpha = 1.0f;
                         
                     }];
}

- (void)hideNoOneView
{
    if (self.noOneView.hidden == YES) {
        return;
    }
    

    self.noOneView.alpha = 1.f;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.noOneView.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         self.noOneView.alpha = 0.f;
                         self.noOneView.hidden = YES;
                     }];
}

- (void)setupImageTouchGesture
{
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(imageTouched:)];
    
    [self.picture addGestureRecognizer:tapGesture];
}

- (void)imageTouched:(id)sender
{
    [[CMAPIClient sharedClient] getNewDoorPictureWithParameters:nil
                                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                            // Get the new picture url from the response object
                                                            // and set it
                                                        } failure:^(NSHTTPURLResponse *response, NSError *error) {
                                                            // Handle error
                                                            
                                                        }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupImageTouchGesture];
    self.noOneView.hidden = NO;
    
    // Round the buttons
    self.omwButton.layer.cornerRadius = 10;
    self.omwButton.clipsToBounds = YES;
    
    self.notHereButton.layer.cornerRadius = 10;
    self.notHereButton.clipsToBounds = YES;
    
    self.sendCustomButton.layer.cornerRadius = 10;
    self.sendCustomButton.clipsToBounds = YES;
    
    self.typeLabel.textColor = [UIColor colorFromHexString:@"0f75bc"];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSArray *doorbells = [CMDoorbell findAll];
    
    for (int i = 0; i < doorbells.count; i++) {
        
        CMDoorbell *bell = doorbells[i];
        
        [[CMAPIClient sharedClient]
         getActiveVisitorsWithDoorbellID:bell.doorbellID
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             @synchronized(_currentDoorbellID) {
                 
                 if (_currentDoorbellID) {
                     return;
                 }
                 
                 NSString *message = [responseObject valueForKey:@"message"];
                 
                 if (message && message.length) {
                     [self showNoOneView];
                 } else {
                     self.currentDoorbellID = bell.doorbellID;
                     
                     NSString *thumbnailURL = [responseObject valueForKey:@"photo_thumbnail_url"];
                     NSString *formattedThumbnailURL;
                     if (thumbnailURL.length) {
                         formattedThumbnailURL = [NSString stringWithFormat:@"%@=s%@", thumbnailURL, @"256"];
                         
                         [self.picture setImageWithURL:[NSURL URLWithString:formattedThumbnailURL]
                                      placeholderImage:[UIImage imageNamed:@"history_detail_placeholder"]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                                 [self.picture setImage:image];
                                             }];
                         
                     } else {
                         [self.picture setImage:[UIImage imageNamed:@"history_detail_placeholder±"]];
                     }
                     
                     self.currentVisitorID = [responseObject valueForKey:@"id"];
                     self.title = [bell.name capitalizedString];
                     self.typeLabel.text = [responseObject[@"description"] capitalizedString];
                     
                     if (!self.typeLabel.text) {
                         self.typeLabel.text = @"Visitor";
                     }
                     
                     [self hideNoOneView];
                 }
             }
         }
         failure:^(NSHTTPURLResponse *response, NSError *error) {
             
             @synchronized(_currentDoorbellID) {
                 [self showNoOneView];
                 
             }
         }];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.lastDoorbellID = self.currentDoorbellID;
    
    self.currentDoorbellID = nil;
    [self showNoOneView];
}

- (IBAction)sendCustomTouched:(id)sender
{
    CMCustomResponsesViewController *customResponsesVC =
        [[CMCustomResponsesViewController alloc] initWithNibName:@"CMCustomResponsesViewController" bundle:nil];
    
    customResponsesVC.responderDelegate = self;
    
    [self.navigationController pushViewController:customResponsesVC animated:YES];
    
}

- (IBAction)notHereTouched:(id)sender
{
    [self sendResponse:@"I'm not available right now."];
}

- (IBAction)omwTouched:(id)sender
{
    [self sendResponse:@"I'm on my way!"];
}


@end
