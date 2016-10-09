//
//  FillDataViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/5/1.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "FillDataViewController.h"
#import "RootTabBarController.h"
#import "AppDelegate.h"

@interface FillDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *branchTF;
@property (weak, nonatomic) IBOutlet UITextField *yearTF;
@property (weak, nonatomic) IBOutlet UITextField *yearMeTF;
@property (weak, nonatomic) IBOutlet UIButton *continueAction;
- (IBAction)continueAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (nonatomic, assign)float contentView_y;

@end

@implementation FillDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.branchTF.borderStyle = UITextBorderStyleNone;
    self.yearTF.borderStyle = UITextBorderStyleNone;
    self.yearMeTF.borderStyle = UITextBorderStyleNone;
    self.nickNameTF.borderStyle = UITextBorderStyleNone;
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    //添加监听，监听键盘的弹出和回收。  系统提供的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘回收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.contentView_y = self.contentView.frame.origin.y;
}
#pragma mark--添加监听，监听键盘的弹出和回收。  系统提供的
-(void)keyboardShow:(NSNotification *)notification
{
    // 得到键盘的高度,将字符串转换为矩形
    CGRect keyBoard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyBoardHeight = keyBoard.size.height;
    
    if ((kHeight/2-150) < keyBoardHeight)
    {
        self.contentView.bounds = CGRectMake(0, keyBoardHeight-kHeight/2+150, 200, 300);
    }
    
}
//监听键盘回收
-(void)keyboardHide:(NSNotification *)notification
{
    self.contentView.bounds = CGRectMake(0, 0, 200, 300);
}


#pragma mark---按钮和手势的回调方法
-(void)recoverKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

-(void)continueEntry
{
    NSString *str;
    if (self.branchTF.text == nil | self.branchTF.text.length == 0 | self.branchTF.text == NULL)
    {
        str = @"请输入每日吸烟数";
    }
    else if (self.yearTF.text == nil | self.yearTF.text.length == 0 | self.yearTF.text == NULL)
    {
        str = @"请输入烟龄";
    }
    else if(self.yearMeTF.text == nil | self.yearMeTF.text.length == 0 | self.yearMeTF.text == NULL)
    {
        str = @"请输入年龄";
    }
    else if(self.nickNameTF.text == nil | self.nickNameTF.text.length == 0 | self.nickNameTF.text ==NULL)
    {
        str = @"请输入昵称";
    }
    else
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用软件版本  比如：1.0.1
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        RootTabBarController *rootTBC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootTabBarController"];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = rootTBC;
        //跳过欢迎动画之后切换跟视图控制器
        CurrentUserInfo *currentUI = [CurrentUserInfo sharedCurrentUserIfo];
        currentUI.version = appCurVersion;
        currentUI.smokerAge = self.yearTF.text;
        currentUI.age = self.yearMeTF.text;
        currentUI.everyDaySmokerNumber = self.branchTF.text;
        currentUI.nickname = self.nickNameTF.text;
        //移除本视图
        [self.view removeFromSuperview];
        return;
    }
    
    //弹出框
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:str preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];

}
//继续
- (IBAction)continueAction:(UIButton *)sender
{
    [self continueEntry];
    
    if ([DataManager sharedManager].delegate && [[DataManager sharedManager].delegate respondsToSelector:@selector(updateNewUserData)]) {
        [[DataManager sharedManager].delegate updateNewUserData];
    }
    
    if ([DataManager sharedManager].delegate && [[DataManager sharedManager].delegate respondsToSelector:@selector(uploadUserInfo)]) {
        [[DataManager sharedManager].delegate uploadUserInfo];
    }
    
    
    
}
@end













