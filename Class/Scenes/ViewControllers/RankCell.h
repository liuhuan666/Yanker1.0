//
//  RankCell.h
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
- (void)setCellWithDic:(NSDictionary *)dic;

@end
