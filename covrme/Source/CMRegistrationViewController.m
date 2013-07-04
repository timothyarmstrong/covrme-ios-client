//
//  CMRegistrationViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-04.
//
//

#import "CMRegistrationViewController.h"

@interface CMRegistrationViewController ()

@end

@implementation CMRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
