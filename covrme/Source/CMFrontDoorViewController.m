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
    
    if (!self.currentDoorbellID) {
        self.currentDoorbellID = self.lastDoorbellID;
    }
    
    if (!self.currentVisitorID) {
        self.currentVisitorID = self.lastVisitorID;
    }
    
    self.lastDoorbellID = @"";
    self.lastVisitorID = @"";
    
    [SVProgressHUD showWithStatus:@"Sending reply" maskType:SVProgressHUDMaskTypeBlack];
    
    [[CMAPIClient sharedClient]
         sendMessageToDoorbellID:self.currentDoorbellID
         withVisitorID:self.currentVisitorID
         withMessage:text
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [SVProgressHUD dismiss];
             [self showSuccessMessageAlert];
             
         }
         failure:^(NSHTTPURLResponse *response, NSError *error) {
             [SVProgressHUD dismiss];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupImageTouchGesture];
    self.noOneView.hidden = NO;
    
    // Round the buttons
    self.omwButton.layer.cornerRadius = 10;
    self.omwButton.clipsToBounds = YES;
    [self.omwButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.omwButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    
    self.notHereButton.layer.cornerRadius = 10;
    self.notHereButton.clipsToBounds = YES;
    [self.notHereButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.notHereButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.sendCustomButton.layer.cornerRadius = 10;
    self.sendCustomButton.clipsToBounds = YES;
    [self.sendCustomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendCustomButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.typeLabel.textColor = [UIColor colorFromHexString:@"0f75bc"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkForVisitors];
    [self startPolling];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.lastDoorbellID = self.currentDoorbellID;
    self.lastVisitorID = self.currentVisitorID;
    
    [self showNoOneView];
    [self endPolling];
}

- (IBAction)sendCustomTouched:(id)sender
{
    CMCustomResponsesViewController *customResponsesVC =
        [[CMCustomResponsesViewController alloc] initWithNibName:@"CMCustomResponsesViewController" bundle:nil];
    
    customResponsesVC.responderDelegate = self;
    
    [self.navigationController pushViewController:customResponsesVC animated:YES];
    
}

- (void)startPolling
{
    if (self.pollingTimer) {
        [self.pollingTimer invalidate];
    }
    
    self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(checkForVisitors) userInfo:nil repeats:YES];
}

- (void)endPolling
{
    if (self.pollingTimer) {
        [self.pollingTimer invalidate];
    }
}

- (void)checkForVisitors
{
    [[CMAPIClient sharedClient]
     getActiveVisitorsWithDoorbellID:@"all"
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSString *message = [responseObject valueForKey:@"message"];
         
         if (message && message.length) {
             self.currentDoorbellID = @"";
             self.currentVisitorID = @"";
             [self showNoOneView];
         } else {
             NSDictionary *doorbell = responseObject[@"doorbell"];
             NSDictionary *visitor = responseObject[@"visitor"];
             
             NSString *thumbnailURL = visitor[@"photo_thumbnail_url"];
             NSString *formattedThumbnailURL;
             if (thumbnailURL.length) {
                 formattedThumbnailURL = [NSString stringWithFormat:@"%@=s%@", thumbnailURL, @"256"];
                 
                 [self.picture setImageWithURL:[NSURL URLWithString:formattedThumbnailURL]
                              placeholderImage:[UIImage imageNamed:@"history_detail_placeholder"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                         [self.picture setImage:image];
                                     }];
                 
             } else {
                 [self.picture setImage:[UIImage imageNamed:@"history_detail_placeholder"]];
             }
             
             self.currentDoorbellID = doorbell[@"id"];
             self.currentVisitorID = visitor[@"id"];
             self.title = [doorbell[@"name"] capitalizedString];
             self.typeString = [visitor[@"description"] capitalizedString];
             self.statusString = [visitor[@"status"] lowercaseString];
             
             if (!self.typeLabel.text) {
                 self.typeLabel.text = @"Visitor";
             }
             
             [self configureView];
             [self hideNoOneView];
             [self updateDoorbellWithDoorbellDictionary:doorbell];
         }
     }
     failure:^(NSHTTPURLResponse *response, NSError *error) {
         [self showNoOneView];
     }];
}

- (void)updateDoorbellWithDoorbellDictionary:(NSDictionary *)doorbell
{
    NSArray *results = [CMDoorbell findAllWithPredicate:[NSPredicate predicateWithFormat:@"doorbellID = %@", doorbell[@"id"]]];
    
    if (results.count != 1) {
        NSLog(@"Couldn't find a matching doorbell to update..! wtf!? PredicateID: %@", doorbell[@"id"]);
        return;
    }
    
    CMDoorbell *storedBell = [results firstObject];
    NSString *storedLowerName = [storedBell.name lowercaseString];
    NSString *doorbellLowerName = [doorbell[@"name"] lowercaseString];
    
    
    if (![storedLowerName isEqualToString:doorbellLowerName]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSArray *results = [CMDoorbell findAllWithPredicate:[NSPredicate predicateWithFormat:@"doorbellID = %@", doorbell[@"id"]]];
            
            if (results.count != 1) {
                NSLog(@"Couldn't find a matching doorbell to update..! wtf!? PredicateID: %@", doorbell[@"id"]);
                return;
            }
            
            CMDoorbell *storedBell = [results firstObject];
            
            if (![[storedBell.name lowercaseString] isEqualToString:[doorbell[@"name"] lowercaseString]]) {
                storedBell.name = [doorbell[@"name"] capitalizedString];
            }
        }];
    }
    
    

}

- (void)configureView
{
    if ([self.statusString isEqualToString:@"covered"]) {
        self.omwButton.enabled = NO;
        self.omwButton.alpha = 0.5f;
        
        self.notHereButton.enabled = NO;
        self.notHereButton.alpha = 0.5f;
        
        self.sendCustomButton.enabled = NO;
        self.sendCustomButton.alpha = 0.5f;
        
        self.typeString = @"Covered";
    } else {
        self.omwButton.enabled = YES;
        self.omwButton.alpha = 1.0f;
        
        self.notHereButton.enabled = YES;
        self.notHereButton.alpha = 1.0f;
        
        self.sendCustomButton.enabled = YES;
        self.sendCustomButton.alpha = 1.0f;
    }
    
    self.typeLabel.text = self.typeString;

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
