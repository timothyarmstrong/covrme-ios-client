//
//  CMFrontDoorViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-18.
//
//

#import "CMFrontDoorViewController.h"
#import "CMCustomResponsesViewController.h"
#import "CMAPIClient.h"

@interface CMFrontDoorViewController ()

@end

@implementation CMFrontDoorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Front Door";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"detaileddoor"] tag:0];
        
        self.currentDoorbellID = @"65432353";

    }
    return self;
}

#pragma mark - Private Methods

- (void)sendResponse:(NSString *)text
{
    [[CMAPIClient sharedClient]
         sendMessageToDoorbellID:self.currentDoorbellID
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscribe to a Doorbell"
                                                    message:@"Please enter the ID of the Doorbell you wish to subscribe to"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [[CMAPIClient sharedClient]
         getHistoryWithDoorbellID:self.currentDoorbellID
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *dingDong = [responseObject objectAtIndex:0];
             
             self.currentVisitorID = [dingDong valueForKey:@"Id"];
             
             // RFC3339 date formatting
             NSString *timeStamp = [dingDong valueForKey:@"When"];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ";
             
             NSDate *date;
             NSError *error;
             [formatter getObjectValue:&date
                             forString:timeStamp
                                 range:nil
                                 error:&error];
             
             if (date) {
                 NSTimeInterval secondsBetween =
                    [[NSDate date] timeIntervalSinceDate:date];
                 
                 if ( secondsBetween <= 60) {
                     [self hideNoOneView];
                     return;
                 }
             }
             
             [self showNoOneView];
     
             
         }
         failure:^(NSHTTPURLResponse *response, NSError *error) {
             [self showNoOneView];
         }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
