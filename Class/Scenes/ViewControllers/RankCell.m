//
//  RankCell.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "RankCell.h"

@interface RankCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *score;


@end

@implementation RankCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.headImageV.layer.cornerRadius = 5;
    self.headImageV.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDic:(NSDictionary *)dic{
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headImageURL"]]];
    self.nickName.text = [dic objectForKey:@"nickName"];
    self.score.text = [NSString stringWithFormat:@"得分：%ld",[[dic objectForKey:@"score"] integerValue]];
}

@end
