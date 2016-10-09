//
//  CurrentUserInfo.h
//  Yanker1.0
//
//  Created by xalo on 16/4/30.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserInfo : NSObject
@property (nonatomic, retain) NSString *version;//版本号
@property (nonatomic, retain) NSData   *headImage;//用户图像
@property (strong, nonatomic) NSString *userID;//用户id
@property (nonatomic, retain) NSString *mySign;//个性签名
@property (nonatomic, retain) NSString *nickname;//昵称
@property (nonatomic, assign) BOOL     isHaveHeadimage;//判断是否设置了头像

@property (nonatomic,retain) NSString  *userName;//账号
@property (nonatomic,retain) NSString  *pwd;//密码
@property (nonatomic,retain) NSString  *smokerAge;//烟龄
@property (nonatomic,retain) NSString  *age;//年龄
@property (nonatomic,retain) NSString  *everyDaySmokerNumber;//吸烟目标
@property (assign, nonatomic) NSInteger actualNumber;//本日实际吸烟数

@property (assign, nonatomic) CGFloat score;//得分
@property (nonatomic, assign) NSInteger noSmokeDayNumber;//未吸烟戒烟天数
@property (strong, nonatomic) NSString *lastDate;//上一次启动应用日期
@property (assign, nonatomic) BOOL isCreatedRankdata;//是否已经创建rankdata




+(CurrentUserInfo *)sharedCurrentUserIfo;

@end
