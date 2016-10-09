//
//  LoginViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/5/1.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"
#import "PersonalViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
- (IBAction)LoginBtn:(UIButton *)sender;
- (IBAction)forgetPwd:(UIButton *)sender;
- (IBAction)registerBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *qqImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weiBoImageView;

@end

@implementation LoginViewController
//添加轻拍手势 和有关界面设计
-(void)addTapGestureForImageView
{
    self.qqImageView.userInteractionEnabled = YES;
    self.qqImageView.layer.cornerRadius = 24;
    self.qqImageView.layer.masksToBounds = YES;
    self.qqImageView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap_qq = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqAction:)];
    [self.qqImageView addGestureRecognizer:tap_qq];
    
    self.weiBoImageView.userInteractionEnabled = YES;
    self.weiBoImageView.layer.cornerRadius = 24;
    self.weiBoImageView.layer.masksToBounds = YES;
    self.weiBoImageView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap_weiBo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weiBoAction:)];
    [self.weiBoImageView addGestureRecognizer:tap_weiBo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboardAction:)];
    [self.view addGestureRecognizer:tap];
 
    self.userTF.borderStyle = UITextBorderStyleNone;
    self.pwdTF.borderStyle = UITextBorderStyleNone;
}
#pragma mark--视图的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize: 17],NSFontAttributeName, nil];


    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:116/255.0 green:249/255.0 blue:220/255.0 alpha:1];


    //添加轻拍手势  和有关界面设计
    [self addTapGestureForImageView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

#pragma mark---按钮和手势的回调方法
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//登录
-(void)loginAction
{
    
//    //登出上一个用户
//    [AVUser logOut];
    
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    [AVUser logInWithUsernameInBackground:self.userTF.text   password:self.pwdTF.text   block:^(AVUser *user, NSError *error) {
        if (user != nil)
        {
            //登录成功需要置为nil
            //判断登录没有    在数据储存完成之后再从云端获取数据转移到自己的或第三方的数库中
            if (currentUserInfo.userName)//已经登录,第三方登录与一般登录都解决
            {
                NSLog(@"以前登录过了");
                //登录成功之后需要置为nil的
                [self loginSuccessNeedSetting];
            }
            else
            {
                if (currentUserInfo.everyDaySmokerNumber)
                {
                    RootTabBarController *rootTBC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootTabBarController"];
                    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                    appDelegate.window.rootViewController = rootTBC;
                    //发出通知刷新排行榜
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                }
                NSLog(@"以前未登录");
//                return ;
            }
            
            //清除信息
            [self emptyData];
            
            //登录成功 进入填写资料页面
            NSLog(@"用户已登录成功");
            FillDataViewController *fillDataVC = [[FillDataViewController alloc]initWithNibName:@"FillDataViewController" bundle:nil];
            [self presentViewController:fillDataVC animated:YES completion:nil];
            //将用户名和密码储存到数据库中
            CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
            currentUserInfo.userName = self.userTF.text;
            currentUserInfo.pwd = self.pwdTF.text;
        }
        else
        {
            //弹出框
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

//清空上个用户数据
- (void)emptyData{
  
    if ([[DataManager sharedManager] unArchiver]) {
        
        if ([[DataManager sharedManager].delegate respondsToSelector:@selector(emptyLocalData)]) {
            [[DataManager sharedManager].delegate emptyLocalData];
        }
    }
}

-(void)recoverKeyboardAction:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
//qq的
-(void)qqAction:(UITapGestureRecognizer *)sender
{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
  
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
    {
        
        NSLog(@"code = %d",response.responseCode);
        //          获取qq用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snsAccount.iconURL]]];
            NSData *imageData = UIImagePNGRepresentation(image);
            CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
            currentUserInfo.headImage = imageData;//储存头像到数据库
            currentUserInfo.nickname = snsAccount.userName;//储存昵称到数据库
            currentUserInfo.isHaveHeadimage = YES;//数据库有头像了
            currentUserInfo.userName = snsAccount.usid;//用户账号
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSDictionary *dic = @{@"uid":snsAccount.usid,@"pwd":@"123456"};
            [self createAccountWithUserInfo:dic];
            
//            //云端同步数据
//            if ([DataManager sharedManager].delegate && [[DataManager sharedManager].delegate respondsToSelector:@selector(updateNewUserData)]) {
//                [[DataManager sharedManager].delegate updateNewUserData];
//            }
            
            //登录成功 进入填写资料页面
            FillDataViewController *fillDataVC = [[FillDataViewController alloc]initWithNibName:@"FillDataViewController" bundle:nil];
            [self presentViewController:fillDataVC animated:YES completion:nil];
        }
        else
        {
            NSLog(@"------%@",response.message);
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:response.message preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    });
    
}

//微博的
-(void)weiBoAction:(UITapGestureRecognizer *)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
    {
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snsAccount.iconURL]]];
            NSData *imageData = UIImagePNGRepresentation(image);
            CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
            currentUserInfo.headImage = imageData;//储存头像到数据库
            currentUserInfo.nickname = snsAccount.userName;//储存昵称到数据库
            currentUserInfo.isHaveHeadimage = YES;//数据库有头像了
            currentUserInfo.userName = snsAccount.usid;//用户账号
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
         
            NSDictionary *dic = @{@"uid":snsAccount.usid,@"pwd":@"123456"};
            [self createAccountWithUserInfo:dic];
            

            
            
            //登录成功 进入填写资料页面
            FillDataViewController *fillDataVC = [[FillDataViewController alloc]initWithNibName:@"FillDataViewController" bundle:nil];
            [self presentViewController:fillDataVC animated:YES completion:nil];
        }
        else
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:response.message preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    });
}
//登录
- (IBAction)LoginBtn:(UIButton *)sender
{
    NSString *str;
    if (self.userTF.text == nil | self.userTF.text.length == 0 | self.userTF.text == NULL)
    {
        str = @"请输入账号";
    }
    else if (self.pwdTF.text == nil | self.pwdTF.text.length == 0 | self.pwdTF.text == NULL)
    {
        str = @"请输入密码";
    }
    else
    {
        [self loginAction];
        return;
    }
    //弹出框
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:str preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}
//忘记密码
- (IBAction)forgetPwd:(UIButton *)sender
{
    ForgetPwdViewController *forgetPwdVC = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}
//注册
- (IBAction)registerBtn:(UIButton *)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginSuccessNeedSetting{
    
}

//第三方登录成功，拉取用户信息，创建AVUser实例
- (void)createAccountWithUserInfo:(NSDictionary *)userInfo{
    
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = userInfo[@"uid"];// 设置用户名
    user.password =  userInfo[@"pwd"];// 设置密码
    //    user.email = @"tom@leancloud.cn";// 设置邮箱
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            [self loginWithUserName:user.username password:user.password];
        } else {
            
            if (error.code == 202) {
                [self loginWithUserName:user.username password:user.password];
            }
            
            
        }
    }];
}
//登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)passWord{
    [AVUser logInWithUsernameInBackground:userName password:passWord block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            //清除信息
            [self emptyData];
            NSLog(@"登录成功");
        } else {
            
        }
    }];
}
@end













