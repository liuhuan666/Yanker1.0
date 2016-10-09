//
//  MeViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "MeViewController.h"
#import "PersonalViewController.h"//个人信息的
#import "RemindViewController.h"//提醒模式的
#import "AboutMeViewController.h"//关于我们
#import "NoDutyViewController.h"//免责声明
#import "PersonInfoTableViewCell.h"
#import "loginCell.h"
#import "otherCell.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UIView *againGoalView;//重置目标
@property (nonatomic,retain)PersonInfoTableViewCell *cell;
@property (nonatomic,retain)UITextField *numberTF;//重置目标数
@end

@implementation MeViewController
-(UIView *)againGoalView
{
    if (!_againGoalView)
    {
        _againGoalView = [[UIView alloc]initWithFrame:self.view.bounds];
        _againGoalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 50)];
        centerView.center = self.tableView.center;
        centerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        UILabel *everyDaylable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 50)];
        everyDaylable.textColor = [UIColor whiteColor];
        everyDaylable.font = [UIFont systemFontOfSize:20];
        everyDaylable.textAlignment = NSTextAlignmentCenter;
        everyDaylable.text = @"每日";
        
        UILabel *zhiLable = [[UILabel alloc]initWithFrame:CGRectMake(15+90+30, 0, 30, 50)];
        zhiLable.textColor = [UIColor whiteColor];
        zhiLable.text = @"支";
        zhiLable.font = [UIFont systemFontOfSize:20];
        zhiLable.textAlignment = NSTextAlignmentCenter;
        
        self.numberTF = [[UITextField alloc]initWithFrame:CGRectMake(15+60,4, 60, 45)];
        self.numberTF.textColor = [UIColor whiteColor];
        self.numberTF.borderStyle = UITextBorderStyleNone;
        self.numberTF.keyboardType = UIKeyboardTypeNumberPad;
        self.numberTF.font = [UIFont systemFontOfSize:20];
        self.numberTF.textAlignment = NSTextAlignmentCenter;
    
        UIView *underlineView = [[UIView alloc]initWithFrame:CGRectMake(75, 47, 60, 1)];
        underlineView.backgroundColor = [UIColor whiteColor];
        
        
        [centerView addSubview:self.numberTF];
        [centerView addSubview:zhiLable];
        [centerView addSubview:everyDaylable];
        [centerView addSubview:underlineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
        [_againGoalView addGestureRecognizer: tap];
        
        [_againGoalView addSubview:centerView];
    }
    return _againGoalView;
}
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}

#pragma mark--视图的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = kColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.translucent = NO;
    //添加tableview
    [self.view addSubview:self.tableView];
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonInfoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"loginCell" bundle:nil] forCellReuseIdentifier:@"loginCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"otherCell" bundle:nil] forCellReuseIdentifier:@"otherCell"];
    
    //接收通知 当用户换了头像之后，这里的头像立马换掉
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageHeadImageAction:) name:@"chageHeadImage" object:nil];
    
}
#pragma mark---手势的回调方法
//通知回调
-(void)chageHeadImageAction:(NSNotification *)sender
{
    [self.tableView reloadData];
}
//重置目标页面移除
-(void)backAction
{
    [self.againGoalView endEditing:YES];
    [self.againGoalView removeFromSuperview];
    //重置目标之后要把新的数据储存到数据库
    CurrentUserInfo *currentUI = [CurrentUserInfo sharedCurrentUserIfo];
    if (self.numberTF.text.length > 0)
    {
        currentUI.everyDaySmokerNumber = self.numberTF.text;
    }
    
}

#pragma mark---tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTableViewCell" forIndexPath:indexPath];
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
        self.cell.headImagView.layer.cornerRadius = (self.cell.frame.size.height-10)/2;
        self.cell.headImagView.layer.masksToBounds = YES;
        if (currentUserInfo.isHaveHeadimage)
        {
            NSData *data = currentUserInfo.headImage;
            self.cell.headImagView.image = [UIImage imageWithData:data];
            self.cell.titleLable.text = currentUserInfo.nickname;
        }
        else
        {
            self.cell.headImagView.image = [UIImage imageNamed:@"userHeader.png"];
            self.cell.titleLable.text = @"昵称";
            self.cell.titleLable.textColor = [UIColor blackColor];
        }
        self.cell.backgroundColor = [UIColor whiteColor];
        return self.cell;

    }
    else if (indexPath.section == 3)
    {
        //判断是否登录
        CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
        loginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.loginLable.textColor = [UIColor blackColor];
//        if (currentUserInfo.userName != nil && currentUserInfo.pwd != nil)
//        {
//            cell.loginLable.text = @"切换账号";
//        }
//        else
//        {
//            cell.loginLable.text = @"登录";
//        }
        
        if ([AVUser currentUser]) {
            cell.loginLable.text = @"切换账号";
        }else{
            cell.loginLable.text = @"登录";
        }
        
        
        
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else
    {
        otherCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell" forIndexPath:indexPath];
        otherCell.othertitleLable.textColor = [UIColor blackColor];
        otherCell.backgroundColor = [UIColor whiteColor];
        otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.section)
        {
            case 1:
            {
                if (indexPath.row == 0)
                {
                    otherCell.othertitleLable.text = @"重置目标";
                    otherCell.leftImageView.image = [UIImage imageNamed:@"setting_goal2.png"];
                    
                }
                else if (indexPath.row == 1)
                {
                    otherCell.othertitleLable.text = @"清除本地数据";
                    otherCell.leftImageView.image = [UIImage imageNamed:@"clearn.png"];
                }
                else if (indexPath.row == 2)
                {
                    otherCell.othertitleLable.text = @"提醒模式";
                    otherCell.leftImageView.image = [UIImage imageNamed:@"remind.png"];
                }
                return otherCell;
            }
                break;
            case 2:
            {
                if (indexPath.row == 0)
                {
                    otherCell.othertitleLable.text = @"关于我们";
                    otherCell.leftImageView.image = [UIImage imageNamed:@"aboutMe2.png"];
                }
                else if (indexPath.row == 1)
                {
//                    otherCell.othertitleLable.text = @"评分及意见反馈";
//                    otherCell.leftImageView.image = [UIImage imageNamed:@"feedback.png"];
                    otherCell.othertitleLable.text = @"服务条款";
                    otherCell.leftImageView.image = [UIImage imageNamed:@"statement2.png"];
                }
                else if (indexPath.row == 2)
                {
                    otherCell.othertitleLable.text = @"服务条款";
                    otherCell.leftImageView.image = [UIImage imageNamed:@"statement.png"];
                }
                return otherCell;
            }
                break;
            default:
                break;
        }
    }
    return self.cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"PersonalViewController" bundle:nil];
            PersonalViewController *personalVC = [story instantiateViewControllerWithIdentifier:@"PersonalViewController"];
            [self.navigationController pushViewController:personalVC animated:YES];
            
            self.tabBarController.tabBar.hidden = YES;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0)
            {
                //重置目标
                [self.view addSubview:self.againGoalView];
            }
            else if (indexPath.row == 1)
            {
                //清除本地数据
                [self alertViewControllerWithTitle:nil message:@"是否清除本地数据"];
            }
            else if (indexPath.row == 2)
            {
                RemindViewController *remindVC = [[RemindViewController alloc]init];
                [self.navigationController pushViewController:remindVC animated:YES];
                self.tabBarController.tabBar.hidden = YES;
            }

            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0)
            {
                AboutMeViewController *aboutMeVC = [[AboutMeViewController alloc]initWithNibName:@"AboutMeViewController" bundle:nil];
                [self.navigationController pushViewController:aboutMeVC animated:YES];
                self.tabBarController.tabBar.hidden = YES;
            }
            else if (indexPath.row == 2)
            {
                //评分及意见反馈
            }
            else if (indexPath.row == 1)
            {
                NoDutyViewController *noDutyVC = [[NoDutyViewController alloc]initWithNibName:@"NoDutyViewController" bundle:nil];
                [self.navigationController pushViewController:noDutyVC animated:YES];
                self.tabBarController.tabBar.hidden = YES;
            }
            
        }
            break;
        case 3:
        {
            //切换账号
            LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *navigationC = [[UINavigationController alloc]initWithRootViewController:loginVC];
            //登出当前用户
            [AVUser logOut];
            [self.tableView reloadData];
            
            [self presentViewController:navigationC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            return (kHeight-108)/22*3;
        }
            break;
        case 3:
        {
            return (kHeight-108)/22*3;
        }
            break;
        default:
            return (kHeight-108)/11;
            break;
    }

}


#pragma mark--警示框
//清除本地数据的
-(void)alertViewControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title    message:message delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}
//警示框的代理方法 清除本地数据的
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"本地数据已经清除");
}
@end
