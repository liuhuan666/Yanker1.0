//
//  RemindTableViewCell.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "RemindTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation RemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    [UIApplication sharedApplication]
    // Configure the view for the selected state
}


- (IBAction)switchBtn:(UISwitch *)sender
{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
//    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    RemindTableViewCell *cell = (RemindTableViewCell *)sender.nextResponder.nextResponder;
    if ([cell.titleLable.text isEqualToString:@"推送"])
    {
        NSLog(@"设置推送的");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else if ([cell.titleLable.text isEqualToString:@"声音"])
    {
        NSLog(@"设置声音的");
    }
    else if ([cell.titleLable.text isEqualToString:@"震动"])
    {
        NSLog(@"设置震动的");
    }
    
}
@end
