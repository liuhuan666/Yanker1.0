//
//  RankViewController.m
//  Yanker1.0
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "RankViewController.h"
#import "UITableView+EmptyData.h"

@interface RankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,retain)UIImageView *headImageV;//用户头像
@property(nonatomic,retain)UILabel *nameLabel;//用户昵称
@property(nonatomic,retain)UILabel *lacationLabel;//排名
@property(nonatomic,retain)UILabel *prorateLabel;//百分之前多少
@property (strong, nonatomic) NSMutableArray *rankDataSource;//rank数据源
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;


@end

@implementation RankViewController
#pragma mark -- 属性懒加载
- (NSMutableArray *)rankDataSource{
    if (!_rankDataSource) {
        _rankDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _rankDataSource;
}

//设置navcBar
- (void)setupNavcBar{
  
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = kColor;
    self.navigationItem.title = @"排行";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharedAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData:)];
}
- (void)cretedUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight/6)];
    headview.backgroundColor = kColor;
    self.headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 40, 40)];
    self.headImageV.layer.cornerRadius= 20;
    self.headImageV.layer.masksToBounds  =YES;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 25, 100, 20)];
    [headview addSubview:self.headImageV];
    
    //判断是否设置了头像
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    if (currentUserInfo.isHaveHeadimage)
    {
        NSData *data = currentUserInfo.headImage;
        self.headImageV.image = [UIImage imageWithData:data];
        self.nameLabel.text = currentUserInfo.nickname;
    }
    else
    {
        self.headImageV.image = [UIImage imageNamed:@"userHeader.png"];
        self.nameLabel.text = @"昵称--";
    }
    
    self.lacationLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,kHeight/6-25, 130, 20)];
    self.lacationLabel.text  = @"我的位置:--名";
    self.prorateLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, kHeight/6-25, 150, 20)];
    self.prorateLabel.text = @"前:--";
    self.nameLabel.textColor = [UIColor blackColor];
    self.lacationLabel.textColor = [UIColor blackColor];
    self.prorateLabel.textColor = [UIColor blackColor];
    [headview addSubview:self.nameLabel];
    [headview addSubview:self.lacationLabel];
    [headview addSubview:self.prorateLabel];
    _tableView.tableHeaderView = headview;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"RankCell" bundle:nil] forCellReuseIdentifier:@"CELL1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线
    [_tableView addSubview:self.effectView];
    [self.view addSubview:_tableView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self cretedUI];
    [self setupNavcBar];
    
    //如果当前用户已经登录，加载一次数据
    [self refreshData:nil];
    
    //接收通知 当用户换了头像之后，这里的头像立马换掉
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageHeadImageAction:) name:@"chageHeadImage" object:nil];
    //切换账号后接收通知刷新UI
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
}
#pragma mark -- 接收通知回调
//通知回调
-(void)chageHeadImageAction:(NSNotification *)sender
{
    //判断是否设置了头像
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    NSData *data = currentUserInfo.headImage;
    self.headImageV.image = [UIImage imageWithData:data];
    self.nameLabel.text = currentUserInfo.nickname;
}

#pragma mark ---------------------- tableView的代理方法 ------------------------------
//返回cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableView showMessage:@"用户未登录" byDataSourceCount:self.rankDataSource.count];
    
}
//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL1" forIndexPath:indexPath];
    NSDictionary *dic = self.rankDataSource[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    [cell setCellWithDic:dic];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark ------------------------- 控件回调方法 ----------------------------
//友盟社会化分享
- (void)sharedAction:(UIBarButtonItem *)sender{
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"57238b6367e58ecf54004f09"
                                      shareText:@"欢迎加入Yanker，www.github.com/guoliang1206"
                                     shareImage:[UIImage imageNamed:@"share.jpg"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:nil];
}
//刷新数据
- (void)refreshData:(UIBarButtonItem *)sender{
    [sender setEnabled:NO];
    
    if ([AVUser currentUser]) {
        [self.rankDataSource removeAllObjects];
        [self fetchAllRankData];
    }else{
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        NSLog(@"请登录后查看排行");
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请登录后查看排行榜" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark ------------------------- 数据请求方法 -----------------------------

//请求排行数据
- (void)requestRankData{
    //请求出排行数据，然后添加到本地数据源容器中
    if ([CurrentUserInfo sharedCurrentUserIfo].userID) {
        //用户已经登录,从云端请求rank数据
        [self.rankDataSource addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5"]];
    }else{
        //用户还未登录
        [self.rankDataSource removeAllObjects];
    }
}
- (void)fetchAllRankData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AVQuery *query = [AVQuery queryWithClassName:@"RankData"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSArray<AVObject *> *datas = objects;
    
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
            for (AVObject *data in datas) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                NSLog(@"data = %@",data);
                [dic setObject:[data objectForKey:@"headImageURL"] forKey:@"headImageURL"];
                [dic setObject:[data objectForKey:@"nickName"] forKey:@"nickName"];
                [dic setObject:[data objectForKey:@"score"] forKey:@"score"];
                [dic setObject:[data objectForKey:@"objectId"] forKey:@"objectId"];
                
                [temp addObject:dic];
            }
  
            //对数组进行排序
            [self sortArray:temp];
            [self setHeadViewinfo];
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationItem.leftBarButtonItem setEnabled:YES];
        }];
}
//对数组按成绩进行排序
- (void)sortArray:(NSArray *)array{
    
    NSSortDescriptor  *sortDesc = [[NSSortDescriptor  alloc]initWithKey:@"score" ascending:NO];
   [self.rankDataSource addObjectsFromArray:[array sortedArrayUsingDescriptors:@[sortDesc]]];
}
//得到当前用户的rankData
- (AVObject *)getCurrentUserRankData{
    
    if ([AVUser currentUser]) {
        AVQuery *rankDataQuery = [AVQuery queryWithClassName:@"RankData"];
        [rankDataQuery whereKey:@"createdBy" equalTo:[AVUser currentUser]];
        AVObject *rankData = [rankDataQuery getFirstObject];
        return rankData;
    }
    return nil;
}
//设置头视图的信息
- (void)setHeadViewinfo{
    
    AVObject *rankData = [self getCurrentUserRankData];
    NSInteger index = -1;
    NSString *rankid_1 = [rankData objectForKey:@"objectId"];
    for (int i = 0 ; i < self.rankDataSource.count; i++) {
        NSString *rankid_2 = self.rankDataSource[i][@"objectId"];
        if ([rankid_1 isEqualToString:rankid_2]) {
            index = i;
        }
    }

    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:[rankData objectForKey:@"headImageURL"]]];
    self.nameLabel.text = [rankData objectForKey:@"nickName"];
    self.lacationLabel.text = [NSString stringWithFormat:@"我的位置：%ld",index+1];
    self.prorateLabel.text = [NSString stringWithFormat:@"今日得分：%@",[rankData objectForKey:@"score"]];
}
#pragma 通知的回调 刷新UI
-(void)reloadData
{
    [self.tableView reloadData];
}
@end
