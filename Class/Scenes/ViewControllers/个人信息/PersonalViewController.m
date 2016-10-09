//
//  PersonalViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "PersonalViewController.h"
#import "AppDelegate.h"

@interface PersonalViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UILabel *userName;//账号
@property (weak, nonatomic) IBOutlet UILabel *smokerAge;//烟龄
@property (weak, nonatomic) IBOutlet UILabel *age;//年龄
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取个人信息
    [self getDataFromStorage];
    
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    self.userName.text = currentUserInfo.userName;
    self.smokerAge.text = currentUserInfo.smokerAge;
    self.age.text = currentUserInfo.age;
    self.nicknameTF.text = currentUserInfo.nickname;
    
    self.headImageView.layer.cornerRadius = 40;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    if (currentUserInfo.isHaveHeadimage)
    {
        NSData *data = currentUserInfo.headImage;
        self.headImageView.image = [UIImage imageWithData:data];
    }
    else
    {
        self.headImageView.image = [UIImage imageNamed:@"userHeader.png"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickImageFromSystom:)];
    [self.headImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapRecoverKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboard)];
    [self.view addGestureRecognizer:tapRecoverKeyboard];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserInfo:)];
    
}
#pragma mark--添加监听，监听键盘的弹出和回收。  系统提供的
-(void)keyboardShow:(NSNotification *)notification
{
    // 得到键盘的高度,将字符串转换为矩形
    CGRect keyBoard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyBoardHeight = keyBoard.size.height;
    self.view.bounds = CGRectMake(0, keyBoardHeight-50, kWidth, kHeight);
    
}
//监听键盘回收
-(void)keyboardHide:(NSNotification *)notification
{
    self.view.bounds = CGRectMake(0, 0, kWidth, kHeight);
}

#pragma mark---手势和按钮的回调方法 选取照片
-(void)recoverKeyboard
{
    [self.view endEditing:YES];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
//    //储存个人信息到数据库
//    [self storagePersonalInfo];
}

//保存用户信息
- (void)saveUserInfo:(UIBarButtonItem *)sender{
    
    [self storagePersonalInfo];
    //更新用户信息 headImage 、nickName
    [self updateUserInfoToCloud];
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)updateUserInfoToCloud{
    //1.将当前的headimage存储到cloud，并获得图片的url
    NSData *imageData = [CurrentUserInfo sharedCurrentUserIfo].headImage;
    AVFile *file = [AVFile fileWithName:@"headImage.png" data:imageData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
             //2.取出当前的rankdata对象，将其nickName、headimage更新
            AVQuery *rankDataQuery = [AVQuery queryWithClassName:@"RankData"];
            [rankDataQuery whereKey:@"createdBy" equalTo:[AVUser currentUser]];
            AVObject *rankData = [rankDataQuery getFirstObject];
            [rankData setObject:file.url forKey:@"headImageURL"];
            
            [rankData setObject:[CurrentUserInfo sharedCurrentUserIfo].nickname forKey:@"nickName"];
            //更新对象
            [rankData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"更新成功");
                }
            }];
        }
    }];
}


-(void)pickImageFromSystom:(UITapGestureRecognizer *)sender
{
    UIImagePickerController *pickC = [[UIImagePickerController alloc]init];
    pickC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickC.allowsEditing = YES;
    pickC.delegate = self;
    [self presentViewController:pickC animated:YES completion:nil];
}
#pragma mark---选取照片的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headImageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark------------ 数据持久化--------------------
- (void)showAlertWithMessage:(NSString *)message{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
//将userinfo存储到本地
-(void)storagePersonalInfo
{
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    
    if (!self.nicknameTF.text.length) {
        NSLog(@"姓名为空 不可以");
        [self showAlertWithMessage:@"资料不能为空"];
    }else{
        currentUserInfo.nickname = self.nicknameTF.text;
        NSData *data = UIImagePNGRepresentation(self.headImageView.image);
        currentUserInfo.headImage = data;
        if (currentUserInfo.headImage != nil && currentUserInfo.nickname != nil)
        {
            currentUserInfo.isHaveHeadimage = YES;
        }
        //发送通知让该换头像的界面换头像
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chageHeadImage" object:self.headImageView.image];
    }
}

//从本地读取userinfo
-(void)getDataFromStorage
{
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    self.nicknameTF.text = currentUserInfo.nickname;

    NSData *data = currentUserInfo.headImage;
    self.headImageView.image = [UIImage imageWithData:data];
}

@end









