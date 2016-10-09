//
//  WelcomeViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/30.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIPageControl *page;

@end

@implementation WelcomeViewController
//欢迎动画
-(void)createImageView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(kWidth*4, kHeight);
    
    NSArray *infoArray = @[@"你从未关注自己的吸烟情况",@"每天你都在摄入不必要的有害物质",@"你让自己的身体一天天变坏",@"我们提醒你警惕伤害"];
    for (int i=0; i<4; i++)
    {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight)];
        self.imageView.backgroundColor = kColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, kHeight/3.0, kWidth-50, kHeight/3.0)];
       
        label.text = infoArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        [self.imageView addSubview:label];
        
        
        
        
        if (i == 3)
        {
            self.imageView.userInteractionEnabled = YES;
            [self createBtnWithTitle:@"登录" action:@selector(loginAction:) frame:CGRectMake(50, kHeight-100, 60, 50)];

            [self createBtnWithTitle:@"跳过" action:@selector(skipAction:) frame:CGRectMake(kWidth-110, kHeight - 100, 60, 50)];

        }
        [self.scrollView addSubview:self.imageView];
    }
    [self.view addSubview:self.scrollView];
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    self.page.numberOfPages = 4;
    self.scrollView.delegate = self;
    [self.view addSubview:self.page];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加欢迎动画
    [self createImageView];
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    currentUserInfo.noSmokeDayNumber = 1;
}

//创建按钮
-(void)createBtnWithTitle:(NSString *)title action:(SEL)action frame:(CGRect)frame
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button  setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor whiteColor]];
    [button setFrame:frame];

    [self.imageView addSubview:button];
}
#pragma mark--按钮的回调方法
//登录按钮
-(void)loginAction:(UIButton *)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navigationC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:navigationC animated:YES completion:nil];
}
//注册按钮
-(void)registerAction:(UIButton *)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
//跳过按钮的
-(void)skipAction:(UIButton *)sender
{
    //登录成功 进入填写资料页面
    FillDataViewController *fillDataVC = [[FillDataViewController alloc]initWithNibName:@"FillDataViewController" bundle:nil];
    [self presentViewController:fillDataVC animated:YES completion:nil];
}
#pragma mark--滚动视图的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float contentOffset_x = self.scrollView.contentOffset.x;
    if (contentOffset_x == 0)
    {
        self.page.currentPage = 0;
    }
    else if (contentOffset_x == kWidth)
    {
        self.page.currentPage = 1;
    }
    else if (contentOffset_x == 2*kWidth)
    {
        self.page.currentPage = 2;
    }
    else
    {
        self.page.currentPage = 3;
    }
}
@end
