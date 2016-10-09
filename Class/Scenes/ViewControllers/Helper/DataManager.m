//
//  DataManager.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/5.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (DataManager *)sharedManager{
    static DataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DataManager alloc] init];
    });
    return dataManager;
}



//保存数据--归档
- (void)archiverWithUserData:(UserDataModel *)userData{
    //创建一个可变的data对象，用来存储对象
    NSMutableData *receiveMutableData = [NSMutableData data];
    //创建归档工具类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:receiveMutableData];
    //归档
    [archiver encodeObject:userData forKey:@"userData"];
    //归档结束
    [archiver finishEncoding];
    
    //构造存储路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userData"];
    //存储数据
    [receiveMutableData writeToFile:path atomically:YES];
    
}

//读取数据--反归档
- (UserDataModel *)unArchiver{
    //得到文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"userData"];
    //从路径中得到data ,因为存储的是一个NSData类型，所以我们读取出来的数据也是NSData类型
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    //反归档工具
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //反归档成对象
    UserDataModel *userData = [unArchiver decodeObjectForKey:@"userData"];
    //反归档结束
    [unArchiver finishDecoding];
    
//    NSLog(@"dayData ==== %@",userData.dayData);
    
    return userData;
    
}






@end
