//
//  CMTonesViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import "CMTonesViewController.h"
#import "CMAPIClient.h"
#import "SVProgressHUD.h"

@interface CMTonesViewController ()

@end

@implementation CMTonesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Tones";
        
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
        
        [self setupAudioPlayers];
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSDictionary *chosenTone = self.toneEntries[self.lastCheckedPath.row];
    
    NSString *toneFilename = chosenTone[@"filename"];
    
    [SVProgressHUD showWithStatus:@"Saving"];
    
    [[CMAPIClient sharedClient] setDoorbellTone:toneFilename
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            [SVProgressHUD dismiss];
                                            [super viewWillDisappear:animated];
                                            
                                        } failure:^(NSHTTPURLResponse *response, NSError *error) {
                                            [SVProgressHUD dismiss];
                                            [super viewWillDisappear:animated];
                                        }];


}

- (void)setupAudioPlayers
{
    
    NSURL *defaultURL = [[NSBundle mainBundle] URLForResource:@"dingdong"
                                                withExtension:@"wav"];
    
    NSURL *dingDongURL = [[NSBundle mainBundle] URLForResource:@"dingdong"
                                                 withExtension:@"wav"];
    
    NSURL *knockURL = [[NSBundle mainBundle] URLForResource:@"knock"
                                              withExtension:@"wav"];
    
    self.audioPlayers =
    @[
      [[AVAudioPlayer alloc] initWithContentsOfURL:defaultURL error:nil], // default
      [[AVAudioPlayer alloc] initWithContentsOfURL:dingDongURL error:nil],
      [[AVAudioPlayer alloc] initWithContentsOfURL:knockURL error:nil]
      ];
    
    for (AVAudioPlayer *player in self.audioPlayers) {
        [player prepareToPlay];
    }
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
    
    NSDictionary *toneEntry = self.toneEntries[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]
        setObject:toneEntry
           forKey:@"pushtone"];
    
    // Don't play cell 0, default iOS sound
    if (indexPath.row > 0) {
        
        AVAudioPlayer *player = self.audioPlayers[indexPath.row];

        [player play];
    }
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
