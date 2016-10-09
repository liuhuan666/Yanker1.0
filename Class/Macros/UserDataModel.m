//
//  UserDataModel.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/6.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "UserDataModel.h"

@implementation UserDataModel
#pragma mark -- 属性懒加载
- (NSMutableDictionary *)dayData{
    if (!_dayData) {
        _dayData = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dayData;
}
- (NSMutableArray *)weekData{
    if (!_weekData) {
        _weekData = [NSMutableArray arrayWithCapacity:0];
    }
    return _weekData;
}
- (NSMutableArray *)monthData{
    if (!_monthData) {
        _monthData = [NSMutableArray arrayWithCapacity:0];
    }
    return _monthData;
}
#pragma mark -- 归档与反归档方法
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.dayData forKey:@"dayData"];
    [aCoder encodeObject:self.weekData forKey:@"weekData"];
    [aCoder encodeObject:self.monthData forKey:@"monthData"];
    [aCoder encodeObject:self.tarReduce forKey:@"tarReduce"];
    [aCoder encodeObject:self.expectCount forKey:@"expectCount"];
    [aCoder encodeObject:self.actualCount forKey:@"actualCount"];
    [aCoder encodeObject:self.nicotineReduce forKey:@"nicotineReduce"];
    
    [aCoder encodeObject:self.headImage forKey:@"headImage"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeDouble:self.score forKey:@"score"];
    
    NSLog(@"归档的方法已经调用,数据存入");
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.dayData = [aDecoder decodeObjectForKey:@"dayData"];
        self.weekData = [aDecoder decodeObjectForKey:@"weekData"];
        self.monthData = [aDecoder decodeObjectForKey:@"monthData"];
        self.tarReduce = [aDecoder decodeObjectForKey:@"tarReduce"];
        self.expectCount = [aDecoder decodeObjectForKey:@"expectCount"];
        self.actualCount = [aDecoder decodeObjectForKey:@"actualCount"];
        self.nicotineReduce = [aDecoder decodeObjectForKey:@"nicotineReduce"];
        
        self.headImage = [aDecoder decodeObjectForKey:@"headImage"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.score = [aDecoder decodeDoubleForKey:@"score"];
    }
    NSLog(@"反归档方法已经调用，数据读取");
    return self;
}

@end
