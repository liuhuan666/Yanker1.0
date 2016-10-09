
//
//  RegisterViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/5/1.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdFT;
@property (weak, nonatomic) IBOutlet UIButton *registerAction;
- (IBAction)registerAction:(UIButton *)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userTF.borderStyle = UITextBorderStyleNone;
    self.pwdFT.borderStyle = UITextBorderStyleNone;
    self.emailTF.borderStyle = UITextBorderStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboard)];
    [self.view addGestureRecognizer:tap];
    
//    UIDeviceProximityStateDidChangeNotification
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
}
#pragma mark--按钮的点击事件 和警示框的协议方法
-(void)recoverKeyboard
{
    [self.view endEditing:YES];
}
//警示框的代理方法 注册成功之后直接进入填写资料页面，相等于直接登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //登录成功 进入填写资料页面
//    FillDataViewController *fillDataVC = [[FillDataViewController alloc]initWithNibName:@"FillDataViewController" bundle:nil];
//    [self presentViewController:fillDataVC animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//注册
-(void)registerBtnAction
{
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = self.userTF.text;// 设置用户名
    user.password =  self.pwdFT.text;// 设置密码
    user.email = self.emailTF.text;// 设置邮箱
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            NSString *str;
            if (error.code == 125)
            {
                str= @"此邮箱是无效的";
            }
            else if (error.code == 203)
            {
                str = @"此邮箱已经被占用";
            }
            else if (error.code == 202)
            {
                str = @"用户名已经存在";
            }
            NSLog(@"%@",error);
            
            //弹出框
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:str preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

//注册的回调
- (IBAction)registerAction:(UIButton *)sender
{
    NSString *str;
    if (self.userTF.text == nil | self.userTF.text.length == 0 | self.userTF.text == NULL)
    {
        str = @"请输入账号";
    }
    else if (self.pwdFT.text == nil | self.pwdFT.text.length == 0 | self.pwdFT.text == NULL)
    {
        str = @"请输入密码";
    }
    else if(self.emailTF.text == nil | self.emailTF.text.length == 0 | self.emailTF.text == NULL)
    {
        str = @"请输入邮箱";
    }
    else
    {
        [self registerBtnAction];
        return;
    }
    //弹出框
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:str preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];

}















@end
