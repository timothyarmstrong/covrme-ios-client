//
//  CMHistoryDetailViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-28.
//
//

#import "CMHistoryDetailViewController.h"
#import "CMAPIClient.h"
#import "UIImageView+WebCache.h"

@interface CMHistoryDetailViewController ()

@end

@implementation CMHistoryDetailViewController


- (id)initWithDoorbellID:(NSString *)doorbellID visitorID:(NSString *)visitorID
{
    self = [super initWithNibName:@"CMHistoryDetailViewController" bundle:nil];
    
    if (self) {
        self.doorbellID = doorbellID;
        self.visitorID = visitorID;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    [[CMAPIClient sharedClient] getHistoryDetailWithDoorbellID:self.doorbellID
                                                     visitorID:self.visitorID
                                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                           [self parseResponse:responseObject];
                                                           
                                                           [self.tableView reloadData];
                                                           [SVProgressHUD dismiss];
                                                       } failure:^(NSHTTPURLResponse *response, NSError *error) {
                                                           [SVProgressHUD dismiss];
                                                       }];
    
    
}

- (void)parseResponse:(NSDictionary *)response
{
    NSString *thumbnail = [NSString stringWithFormat:@"%@=s%@", [response valueForKey:@"photo_thumbnail_url"], @"300"];
    NSURL *url = [NSURL URLWithString:thumbnail];
    
    __weak CMHistoryDetailViewController *weakSelf = self;
    
    [self.headerImageView setImageWithURL:url
                         placeholderImage:[UIImage imageNamed:@"history_detail_placeholder"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    if (image && cacheType == SDImageCacheTypeNone)
                                    {
                                        weakSelf.headerImageView.alpha = 0.0;
                                        [UIView animateWithDuration:1.0
                                                         animations:^{
                                                             weakSelf.headerImageView.alpha = 1.0;
                                                         }];
                                    }
                                }];
    
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    
    self.typeString = [response valueForKey:@"description"];
    

    // RFC3339 date formatting
    NSString *timeStamp = [response valueForKey:@"when"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ";
    
    NSDate *date;
    NSError *error;
    [formatter getObjectValue:&date forString:timeStamp range:nil error:&error];
    
    NSString *formattedString = [NSDateFormatter localizedStringFromDate:date
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterNoStyle];
    
    self.dateString = formattedString;
    
    formattedString = [NSDateFormatter localizedStringFromDate:date
                                                     dateStyle:NSDateFormatterNoStyle
                                                     timeStyle:NSDateFormatterShortStyle];
    self.timeString = formattedString;
    
    // TODO: Real status string.
    self.statusString = @"Missed";
}

#pragma mark - UITableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:@"CMHistoryDetailTableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:@"CMHistoryDetailTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Date";
                cell.detailTextLabel.text = self.dateString;
                break;
            case 1:
                cell.textLabel.text = @"Time";
                cell.detailTextLabel.text = self.timeString;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Type";
                cell.detailTextLabel.text = self.typeString;
                break;
            case 1:
                cell.textLabel.text = @"Status";
                cell.detailTextLabel.text = self.statusString;
            default:
                break;
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
@end
