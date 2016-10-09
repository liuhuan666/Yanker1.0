//
//  AppDelegate.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"//欢迎动画
#import "RootTabBarController.h"
#import <AVOSCloud/AVOSCloud.h>//使用leanCloud登录注册需要导入的框架

#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
#pragma mark -- 第三方配置
- (void)setup3rd{
    //使用第三方的登录注册需要的
    [AVOSCloud setApplicationId:@"lSIKPoWwlVWCWSINimOPMTJi-gzGzoHsz"
                      clientKey:@"pEKz3eFxxN3yDSv3XKbByRtw"];
    
    //友盟社会化分享
    [UMSocialData setAppKey:@"57238b6367e58ecf54004f09"];
    [self shareConfiguer];
}

- (void)shareConfiguer{
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx5d8d2cad78cf3b41" appSecret:@"8925bf8ce9153170da50ddd97046a37d" url:@"http://www.github.com"];
    
    //微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3512684434"
                                              secret:@"8387c2540e4038652a2718a8d4a56add"
                                         RedirectURL:@"http://www.github.com"];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1105380438" appKey:@"EVdUzmJ8ynPbBIK1" url:@"http://www.github.com"];
    
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
    }
    return result;
}

#pragma mark -- 用户本地数据操作
- (NSInteger)daysSpace{
    //得到本次应用启动时间戳,上一次应用启动的时间戳
    NSString *dateNow = [self dateToStringWithDate:[NSDate date]];
    NSString *lastDate = [CurrentUserInfo sharedCurrentUserIfo].lastDate;
    NSLog(@"dateNow = %@",dateNow);
    NSLog(@"lastDate = %@",lastDate);
    //截取时间子串
    NSString *monthOfNow = [dateNow substringWithRange:NSMakeRange(4, 2)];
    NSString *monthOfLast = [lastDate substringWithRange:NSMakeRange(4, 2)];
    NSString *dayOfNow = [dateNow substringWithRange:NSMakeRange(6, 2)];
    NSString *dayOfLast = [lastDate substringWithRange:NSMakeRange(6, 2)];
    
    NSLog(@"monthofNow = %@",monthOfNow);
    NSLog(@"monthofLast = %@",monthOfLast);
    NSLog(@"dayofNow = %@",dayOfNow);
    NSLog(@"dayOfLast = %@",dayOfLast);
    
    
    
    //计算应用两次使用时间天数间隔
    NSInteger space = (monthOfNow.integerValue - monthOfLast.integerValue)*30 + labs(dayOfNow.integerValue - dayOfLast.integerValue);
    NSLog(@"spaceday  = %ld",space);
    
   
    NSLog(@"updateLastDate = %@",[CurrentUserInfo sharedCurrentUserIfo].lastDate);

    return space;
}


//判断是否经过一天，清空本日数据
- (void)updateDayData{
    if ([self daysSpace] > 0) {
        UserDataModel *model = [[DataManager sharedManager] unArchiver];
        [model.dayData removeAllObjects];
        [[DataManager sharedManager] archiverWithUserData:model];
        //本地吸烟数清零
        [CurrentUserInfo sharedCurrentUserIfo].actualNumber = 0;
    }

}

- (void)updateWeekData{
    if ([self daysSpace] > 0) {
        UserDataModel *model = [[DataManager sharedManager] unArchiver];
        //添加无戒烟操作日期的空白数据，有多少天未操作，就添加多少个空白数据
        for (int i = 0; i < [self daysSpace]; i++) {
            [model.weekData addObject:@(0)];
        }
        //判断数据量是否超过7天,超过7天，移除前面多余数据
        if (model.weekData.count > 7) {
            for (int i = 0; i < model.weekData.count - 7; i++) {
                [model.weekData removeObjectAtIndex:0];
            }
        }
        [[DataManager sharedManager] archiverWithUserData:model];
    }
}

- (void)updateMonthData{
    if ([self daysSpace] > 0) {
        UserDataModel *model = [[DataManager sharedManager] unArchiver];
        //添加无戒烟操作日期的空白数据，有多少天未操作，就添加多少个空白数据
        for (int i = 0; i < [self daysSpace]; i++) {
            [model.monthData addObject:@(0)];
        }
        //判断数据量是否超过30天,超过30天，移除前面多余数据
        if (model.monthData.count > 30) {
            for (int i = 0; i < model.monthData.count - 30; i++) {
                [model.monthData removeObjectAtIndex:0];
            }
        }
        [[DataManager sharedManager] archiverWithUserData:model];
    }
}

//时间转字符串
- (NSString *)dateToStringWithDate:(NSDate *)myDate{
    //设置时间格式的对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeString = [formatter stringFromDate:myDate];
    NSLog(@"timeString = %@",timeString);
    return timeString;
}


- (void)updateLocalData
{
    [self updateDayData];
    [self updateWeekData];
    [self updateMonthData];
}

- (void)updateUsedDaysWithTimeSpace:(NSInteger )timeSpace{
    if (timeSpace > 0) {
        [CurrentUserInfo sharedCurrentUserIfo].noSmokeDayNumber += timeSpace;
    }else{
        [CurrentUserInfo sharedCurrentUserIfo].noSmokeDayNumber += 0;
    }
}

#pragma mark -- AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setup3rd];
    
    //如果间隔天数大于0，则更新一下数据
    NSInteger space = [self daysSpace];
    if (space > 0) {
        [self updateLocalData];
        [self updateUsedDaysWithTimeSpace:space];
    }
    
    
    
    
    //初始化window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 获取当前应用软件版本  比如：1.0.1
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    CurrentUserInfo *currentUI = [CurrentUserInfo sharedCurrentUserIfo];
    //通过版本号来判断是否有欢迎动画
    if ([currentUI.version isEqualToString:appCurVersion])
    {
        RootTabBarController *rootTBC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootTabBarController"];
        self.window.rootViewController = rootTBC;
    }
    else
    {
        //设置欢迎动画为视图的根视图控制器
        WelcomeViewController  *welcomeVC = [[WelcomeViewController alloc]init];
        self.window.rootViewController = welcomeVC;
        [CurrentUserInfo sharedCurrentUserIfo].isCreatedRankdata = NO;
    }
    
    //更新应用的启动日期
    [CurrentUserInfo sharedCurrentUserIfo].lastDate = [self dateToStringWithDate:[NSDate date]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Bathroom.Yanker1_0" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Yanker1_0" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Yanker1_0.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
