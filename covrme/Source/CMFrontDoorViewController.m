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
    }
    return self;
}

#pragma mark - Helper Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupImageTouchGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendCustomTouched:(id)sender
{
    CMCustomResponsesViewController *customResponsesVC =
        [[CMCustomResponsesViewController alloc] initWithNibName:@"CMCustomResponsesViewController" bundle:nil];
    
    [self.navigationController pushViewController:customResponsesVC animated:YES];
    
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
@end
