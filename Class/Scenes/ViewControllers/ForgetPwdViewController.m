//
//  ForgetPwdViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/5/4.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *forgetPwdTF;
- (IBAction)sureBtn:(UIButton *)sender;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.forgetPwdTF.borderStyle = UITextBorderStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboard)];
    [self.view addGestureRecognizer:tap];
}
-(void)recoverKeyboard
{
    [self.view endEditing:YES];
}
//忘记密码
- (IBAction)sureBtn:(UIButton *)sender
{
    [self forgetPwdSetting];
}

//忘记密码
-(void)forgetPwdSetting
{
    if (self.forgetPwdTF.text == nil | self.forgetPwdTF.text.length == 0 | self.forgetPwdTF.text == NULL )
    {
        [self alertViewWithTitle:@"友情提示" message:@"请输入您的邮箱"];
    }
    else
    {
        [AVUser requestPasswordResetForEmailInBackground:self.forgetPwdTF.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                [self alertViewWithTitle:@"友情提示" message:@"请在邮箱查收您的密码"];
            }
            else
            {
                NSString *str;
                if (error.code == 205)
                {
                    str = @"用户的电子邮箱不存在";
                    [self alertViewWithTitle:@"友情提示" message:str];
                }
            }
        }];
    }
}

//警示框
-(void)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end


















