//
//  DataManager.h
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/5.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol DataManagerDelegate <NSObject>

//清空用户本地数据
- (void)emptyLocalData;
//更新用户吸烟数据
- (void)updateNewUserData;
//上传用户个人信息
- (void)uploadUserInfo;
@end

@interface DataManager : NSObject



@property (assign, nonatomic) id<DataManagerDelegate> delegate;


+ (DataManager *)sharedManager;
//归档，存数据
- (void)archiverWithUserData:(UserDataModel *)userData;
//反归档 取数据
- (UserDataModel *)unArchiver;
@end
