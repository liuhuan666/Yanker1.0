//
//  UserDataModel.h
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/6.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataModel : NSObject<NSCoding>

//数据类属性 -- Guo
@property (strong, nonatomic) NSMutableDictionary *dayData;//本日数据
@property (strong, nonatomic) NSMutableArray *weekData;//本周数据
@property (strong, nonatomic) NSMutableArray *monthData;//本月数据
@property (strong, nonatomic) NSNumber *expectCount;//预期数量
@property (strong, nonatomic) NSNumber *actualCount;//实际数量
@property (strong, nonatomic) NSNumber *nicotineReduce;//尼古丁减少吸入量
@property (strong, nonatomic) NSNumber *tarReduce;//焦油减少吸入量

//云端排行数据
@property (assign, nonatomic) CGFloat score;//得分
@property (strong, nonatomic) NSData *headImage;//头像
@property (strong, nonatomic) NSString *nickName;//昵称

@end
