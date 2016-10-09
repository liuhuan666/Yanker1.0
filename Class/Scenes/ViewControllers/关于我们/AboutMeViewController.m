//
//  AboutMeViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //图像logo
    self.headerImageView.image = [UIImage imageNamed:@"logo.png"];
    self.headerImageView.layer.cornerRadius = 50;
    self.headerImageView.layer.masksToBounds = YES;
    
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
