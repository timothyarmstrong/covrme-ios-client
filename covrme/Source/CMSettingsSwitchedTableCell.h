//
//  CMSettingsSwitchedTableCell.h
//  covrme
//
//  Created by Anthony Wong on 2013-06-27.
//
//

#import <UIKit/UIKit.h>

@interface CMSettingsSwitchedTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end
