//
//  NoDutyViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "NoDutyViewController.h"

@interface NoDutyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lable_1;

@end

@implementation NoDutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lable_1.text = @"1.关于第三方登录：通过任何第三方登录使用该应用，本公司将不负任何法律责任";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
