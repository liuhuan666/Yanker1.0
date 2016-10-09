//
//  RootTabBarController.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "RootTabBarController.h"

@interface RootTabBarController ()



@end

@implementation RootTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor    = [UIColor whiteColor];

    
    DataStatisticsViewController *dsVC = [[DataStatisticsViewController alloc] initWithNibName:@"DataStatisticsViewController" bundle:nil];
    TodayViewController *todayVC = [[TodayViewController alloc] initWithNibName:@"TodayViewController" bundle:nil];
    RankViewController *rankVC   = [[RankViewController alloc]initWithNibName:@"RankViewController" bundle:nil];
    MeViewController *meVC       = [[MeViewController alloc]init];
    
    dsVC.title = @"历史记录";
    todayVC.title = @"打卡";
    rankVC.title = @"排行榜";
    meVC.title = @"我的";
    
    
    UINavigationController *navigationDsC = [[UINavigationController alloc]initWithRootViewController:dsVC];
    UINavigationController *navigationTodayC = [[UINavigationController alloc]initWithRootViewController:todayVC];
    UINavigationController *navigationRankC = [[UINavigationController alloc]initWithRootViewController:rankVC];
    UINavigationController *navigationMeC = [[UINavigationController alloc]initWithRootViewController:meVC];
    self.viewControllers = @[navigationDsC,navigationTodayC,navigationRankC,navigationMeC];
    

    UITabBarItem *item_1 = [self.tabBar.items objectAtIndex:0];
    
    
    
    item_1.selectedImage = [[UIImage imageNamed:@"database"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item_1.image = [[UIImage imageNamed:@"database"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item_2 = [self.tabBar.items objectAtIndex:1];
    item_2.selectedImage = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item_2.image = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UITabBarItem *item_3 = [self.tabBar.items objectAtIndex:2];
    item_3.selectedImage = [[UIImage imageNamed:@"rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item_3.image = [[UIImage imageNamed:@"rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item_4 = [self.tabBar.items objectAtIndex:3];
    item_4.selectedImage = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item_4.image = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIColor *selectColor = kColor;
       [item_1 setTitleTextAttributes:[NSDictionary
                                    dictionaryWithObjectsAndKeys: selectColor,
                                    NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item_2 setTitleTextAttributes:[NSDictionary
                                    dictionaryWithObjectsAndKeys: selectColor,
                                    NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item_3 setTitleTextAttributes:[NSDictionary
                                    dictionaryWithObjectsAndKeys: selectColor,
                                    NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item_4 setTitleTextAttributes:[NSDictionary
                                    dictionaryWithObjectsAndKeys: selectColor,
                                    NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.selectedIndex = 1;
    


   
}



@end
