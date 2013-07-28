//
//  CMTonesViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import "CMTonesViewController.h"

@interface CMTonesViewController ()

@end

@implementation CMTonesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.toneEntries =
            @[
              @{ @"name": @"Default", @"filename": @"Default.wav" },
              @{ @"name": @"Ding Dong", @"filename": @"dingdong.wav" },
              @{ @"name": @"Knock", @"filename": @"knock.wav"}
            ];
        
        NSDictionary *currentTone =
        [[NSUserDefaults standardUserDefaults] valueForKey:@"pushtone"];
        
        if (!currentTone) {
            [[NSUserDefaults standardUserDefaults] setObject:self.toneEntries[0]
                                                      forKey:@"pushtone"];
        }
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.lastCheckedPath) {
        UITableViewCell *lastCell =
            [tableView cellForRowAtIndexPath:self.lastCheckedPath];
        
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.lastCheckedPath = indexPath;
    
    [[NSUserDefaults standardUserDefaults]
        setObject:self.toneEntries[indexPath.row]
           forKey:@"pushtone"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:@"CMTonesTableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"CMTonesTableViewCell"];
    }
    
    NSDictionary *tone = self.toneEntries[indexPath.row];

    NSString *toneName = tone[@"name"];
    NSString *toneFilename = tone[@"filename"];
    cell.textLabel.text = [tone valueForKey:@"name"];
    
    NSString *currentTone =
        [[[NSUserDefaults standardUserDefaults]
            valueForKey:@"pushtone"]
         valueForKey:@"filename"];

    
    if ([toneFilename isEqualToString:currentTone]) {
        self.lastCheckedPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = toneName;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toneEntries.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Doorbell Tones";
}
@end
