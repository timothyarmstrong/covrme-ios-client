//
//  CMTonesViewController.h
//  covrme
//
//  Created by Anthony Wong on 2013-07-27.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CMTonesViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *lastCheckedPath;
@property (nonatomic, strong) NSArray *toneEntries;
@property (nonatomic, strong) NSArray *audioPlayers;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
