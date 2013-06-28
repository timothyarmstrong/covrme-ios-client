//
//  CMHistoryListViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-05-18.
//
//

#import "CMHistoryListViewController.h"
#import "UIImageView+WebCache.h"


@interface CMHistoryListViewController ()

@end

@implementation CMHistoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"History";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Methods

#pragma mark - UITableViewDatasource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSUInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
