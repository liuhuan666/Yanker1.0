//
//  CurrentUserInfo.m
//  Yanker1.0
//
//  Created by xalo on 16/4/30.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "CurrentUserInfo.h"

@implementation CurrentUserInfo

//单例
+(CurrentUserInfo *)sharedCurrentUserIfo
{
    static CurrentUserInfo *handle= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[CurrentUserInfo alloc]init];
    });
    return handle;
}







#pragma mark ------------------------- setter ---------------------------------
-(void)setVersion:(NSString *)version
{
    //userdefault做缓存的时候，储存的值不能为nil
    if (version)
    {
        [[NSUserDefaults standardUserDefaults]setObject:version forKey:@"version"];
    }
}
-(void)setNickname:(NSString *)nickname
{
    if (nickname)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
    }
}
-(void)setHeadImage:(NSData *)headImage
{
    if (headImage)
    {
        [[NSUserDefaults standardUserDefaults] setObject:headImage forKey:@"headImage"];
    }
}
-(void)setMySign:(NSString *)mySign
{
    if (mySign)
    {
        [[NSUserDefaults standardUserDefaults] setObject:mySign forKey:@"mySign"];
    }
}
-(void)setIsHaveHeadimage:(BOOL)isHaveHeadimage
{
     [[NSUserDefaults standardUserDefaults] setBool:isHaveHeadimage forKey:@"isHaveHeadimage"];
}
-(void)setUserName:(NSString *)userName
{
    if (userName)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    }
}
-(void)setPwd:(NSString *)pwd
{
    if (pwd)
    {
        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
    }
}
-(void)setSmokerAge:(NSString *)smokerAge
{
    if (smokerAge)
    {
        [[NSUserDefaults standardUserDefaults] setObject:smokerAge forKey:@"smokerAge"];
    }
}
-(void)setAge:(NSString *)age
{
    if (age)
    {
        [[NSUserDefaults standardUserDefaults] setObject:age forKey:@"age"];
    }
}
-(void)setEveryDaySmokerNumber:(NSString *)everyDaySmokerNumber
{
    if (everyDaySmokerNumber)
    {
        [[NSUserDefaults standardUserDefaults] setObject:everyDaySmokerNumber forKey:@"everyDaySmokerNumber"];
    }
}
- (void)setScore:(CGFloat)score{
        [[NSUserDefaults standardUserDefaults] setObject:@(score) forKey:@"score"];
}
-(void)setNoSmokeDayNumber:(NSInteger)noSmokeDayNumber
{
        [[NSUserDefaults standardUserDefaults] setInteger:noSmokeDayNumber forKey:@"noSmokeDayNumber"];
}
- (void)setLastDate:(NSString *)lastDate{
    if (lastDate) {
        [[NSUserDefaults standardUserDefaults] setObject:lastDate forKey:@"lastDate"];
    }
}
- (void)setUserID:(NSString *)userID{
    if (userID) {
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
    }
}
- (void)setIsCreatedRankdata:(BOOL)isCreatedRankdata{
    [[NSUserDefaults standardUserDefaults] setBool:isCreatedRankdata forKey:@"isCreatedRankdata"];
}
- (void)setActualNumber:(NSInteger)actualNumber{
    [[NSUserDefaults standardUserDefaults] setInteger:actualNumber forKey:@"actualNumber"];
}

#pragma mark --------------------------- getter ----------------------------------
-(NSString *)version
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
}
-(NSString *)nickname
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
}
-(NSData *)headImage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"];
}
-(NSString *)mySign
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"mySign"];
}
-(BOOL)isHaveHeadimage
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isHaveHeadimage"];
}
-(NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}
-(NSString *)pwd
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
}
-(NSString *)smokerAge
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"smokerAge"];
}
-(NSString *)age
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
}
-(NSString *)everyDaySmokerNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"everyDaySmokerNumber"];
}
- (CGFloat)score{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"score"] floatValue];
}
-(NSInteger)noSmokeDayNumber
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"noSmokeDayNumber"];
}
- (NSString *)lastDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDate"];
}
- (NSString *)userID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}
- (BOOL)isCreatedRankdata{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isCreatedRankdata"];
}
- (NSInteger)actualNumber{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"actualNumber"];
}

@end
