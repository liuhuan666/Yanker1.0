//
//  RemindViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindTableViewCell.h"


@interface RemindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,nonnull,retain)UITableView *tableView;
@end

@implementation RemindViewController

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark---视图的声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加tableview
    [self.view addSubview:self.tableView];
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"RemindTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemindTableViewCell"];
}
#pragma mark---tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    if (section == 1)
    {
        return 2;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindTableViewCell"];
    switch (indexPath.section)
    {
        case 0:
        {
            cell.titleLable.text = @"推送";
            return cell;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0)
            {
                cell.titleLable.text = @"声音";
                return cell;
            }
            else
            {
                cell.titleLable.text = @"震动";
            }
            
        }
            break;
        default:
            break;
    }
    return cell;
}
@end





