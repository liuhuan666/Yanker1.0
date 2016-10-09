//
//  CalendarViewController.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/4/29.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "TodayViewController.h"
#import "DataManager.h"

@interface TodayViewController ()<UIScrollViewDelegate,DataManagerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *daysLabel;//戒烟天数label
@property (weak, nonatomic) IBOutlet UILabel *goalsLabel;//烟克目标label
@property (weak, nonatomic) IBOutlet UIView *contentView;//背景容器视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//滚动视图
@property (strong, nonatomic) NSMutableArray *progressBarArray;//进度条label数组

@property (weak, nonatomic) IBOutlet UIButton *smokeBtn;
@property (weak, nonatomic) IBOutlet  UIView *progressBar;//进度条＊＊＊＊＊＊＊＊
@property (strong, nonatomic) UIView *redProgress;
@property (assign, nonatomic) CGFloat stepWidth;//progress自增宽度
@property (weak, nonatomic) IBOutlet UILabel *beyoudtipLabel;


@end

@implementation TodayViewController
#pragma mark -- 懒加载
- (NSMutableArray *)progressBarArray{
    if (!_progressBarArray) {
        _progressBarArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _progressBarArray;
}
- (UIView *)redProgress{
    if (!_redProgress) {
        _redProgress = [[UIView alloc] initWithFrame:CGRectZero];
        _redProgress.backgroundColor = kColor;
    }
    return _redProgress;
}

#pragma mark -------------------------- 视图生命周期 -------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataManager sharedManager].delegate = self;
    
    [self setupNavigationBar];
    [self createUI];
    
   
    [self.progressBar addSubview:self.redProgress];
    //设置约束
    [self.redProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.progressBar.mas_left).with.offset(0);
        make.top.equalTo(self.progressBar.mas_top).with.offset(0);
        
        make.width.mas_equalTo([self getRedProgressWidth]);
        make.height.mas_equalTo(self.progressBar.mas_height);
    }];
    
    
    if ([CurrentUserInfo sharedCurrentUserIfo].actualNumber > [CurrentUserInfo sharedCurrentUserIfo].everyDaySmokerNumber.integerValue) {
        self.beyoudtipLabel.hidden = NO;
    }else{
         self.beyoudtipLabel.hidden = YES;
    }
  
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CurrentUserInfo *currentUserInfo = [CurrentUserInfo sharedCurrentUserIfo];
    self.daysLabel.text = [NSString stringWithFormat:@"第%ld天",currentUserInfo.noSmokeDayNumber];
    self.goalsLabel.text = [NSString stringWithFormat:@"烟克目标：%@支",currentUserInfo.everyDaySmokerNumber];
    
   

}
//获得红色条的宽度
- (CGFloat)getRedProgressWidth{
   
    NSInteger averageNum = [CurrentUserInfo sharedCurrentUserIfo].everyDaySmokerNumber.integerValue;
    NSInteger actualNum = [CurrentUserInfo sharedCurrentUserIfo].actualNumber;
   
    if (averageNum != 0) {
        
    }
    self.stepWidth = kWidth/2.5/(float)averageNum;
    CGFloat actualWidth = 0.0;
    CGFloat value = (float)actualNum/(float)averageNum;
    
    if (value >= 1.0) {
        actualWidth = kWidth/2.5;
    }else if(value == 0){
        actualWidth = 0.0;
        
    }else{
        actualWidth = kWidth/2.5 * value;
    }
    return actualWidth;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -------------------------- 视图设置方法 ---------------------------------
//NavigationBar 设置
- (void)setupNavigationBar{
    self.navigationItem.title = @"Yanker";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = kColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

//初始化界面
- (void)createUI{
   
    self.smokeBtn.layer.cornerRadius = 50;
    self.smokeBtn.layer.masksToBounds = YES;
    self.smokeBtn.backgroundColor = kColor;
    
}



#pragma mark ------------------------------ 控件回调方法 -----------------------------------
//初始化首次数据
- (UserDataModel *)createdFirstDataWithModel:(UserDataModel *)model{
    if (!model) {
        model = [[UserDataModel alloc] init];
    }
    
    [model.weekData addObject:@(0)];
    [model.monthData addObject:@(0)];
    model.expectCount = @(0);
    model.actualCount = @(0);
    model.nicotineReduce = @(0.0);
    model.tarReduce = @(0.0);
    [[DataManager sharedManager] archiverWithUserData:model];
    return model;
}


//抽烟点击方法
- (IBAction)smokeAdd:(UIButton *)sender {
    
    [self animationForClick];
    
    UserDataModel *userData = nil;
    if (![[DataManager sharedManager] unArchiver]) {
       userData =  [self createdFirstDataWithModel:userData];
    }else{
        userData = [[DataManager sharedManager] unArchiver];
    }
    
    /*
     用户点击过快，快过一秒 会造成当天数据数量 少于总数量
     */
    [userData.dayData setObject:@"1 smoke" forKey:[self dateToStringWithDate:[NSDate date]]];
    NSNumber *weekData =  userData.weekData.lastObject;
    weekData = @(weekData.integerValue + 1);
    [userData.weekData replaceObjectAtIndex:userData.weekData.count - 1 withObject:weekData];
    NSNumber *monthData = userData.monthData.lastObject;
    monthData = @(monthData.integerValue + 1);
    [userData.monthData replaceObjectAtIndex:userData.monthData.count - 1 withObject:monthData];
    NSNumber *actualCount = userData.actualCount;
    userData.actualCount = @(actualCount.integerValue + 1);
    NSNumber *nicotineReduce = userData.nicotineReduce;
    userData.nicotineReduce = @(nicotineReduce.floatValue + 0.3);
    NSNumber *tarReduce = userData.tarReduce;
    userData.tarReduce = @(tarReduce.floatValue + 0.8);
    
    [CurrentUserInfo sharedCurrentUserIfo].actualNumber += 1;
    //归档
    [[DataManager sharedManager] archiverWithUserData:userData];
    
    
    /*
     判断rankdata是否存在。以更新rankdata或者初始化rankdata
     */
    
    if ([self isRankDataExists]) {
        NSLog(@"本日已经吸烟数------%ld",[CurrentUserInfo sharedCurrentUserIfo].actualNumber);
        
        [CurrentUserInfo sharedCurrentUserIfo].score = 100 - [CurrentUserInfo sharedCurrentUserIfo].actualNumber*2;
        [self updateRankDataWithScore:[CurrentUserInfo sharedCurrentUserIfo].score];
    }else{
        [self uploadRankToCloud];
    }
    
    
}

- (void)animationForClick{
    UIView *addOneView = [[UIView alloc]initWithFrame:CGRectMake(kWidth/2-25,self.smokeBtn.center.y, 50, 50)];
    addOneView.layer.cornerRadius = 25;
    addOneView.layer.masksToBounds = YES;
    addOneView.backgroundColor = kColor;
    [self.view addSubview:addOneView];
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    textLable.textAlignment = NSTextAlignmentCenter;
    textLable.text = @"+1";
    [addOneView addSubview:textLable];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if ([CurrentUserInfo sharedCurrentUserIfo].actualNumber == [CurrentUserInfo sharedCurrentUserIfo].everyDaySmokerNumber.integerValue) {
            self.beyoudtipLabel.hidden = NO;
        }
        
        //写要改变的属性
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        addOneView.frame = CGRectMake(kWidth/2-25, kHeight/3, 50, 50);
        addOneView.alpha = 0.2;
        
        if (self.redProgress.frame.size.width < self.progressBar.frame.size.width) {
            CGRect frame = self.redProgress.frame;
            frame.size.width += self.stepWidth;
            self.redProgress.frame = frame;
        }
    } completion:^(BOOL finished) {
        [textLable removeFromSuperview];
        [addOneView removeFromSuperview];
        
    }];
    
   
    
}




//判断rankData是否生成
- (BOOL)isRankDataExists{
    
    if ([AVUser currentUser]) {
        AVQuery *rankDataQuery = [AVQuery queryWithClassName:@"RankData"];
        [rankDataQuery whereKey:@"createdBy" equalTo:[AVUser currentUser]];
        AVObject *rankData = [rankDataQuery getFirstObject];
        
        if (rankData) {
            return YES;
        }
    }
    return NO;
}
//时间转字符串
- (NSString *)dateToStringWithDate:(NSDate *)myDate{
    //设置时间格式的对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss.SSS";
  
    NSString *timeString = [formatter stringFromDate:myDate];
      NSLog(@"date = %@",timeString);
    return timeString;
}


#pragma mark ------------------------- 上传Rank信息 ---------------------------
//上传rank信息
- (void)uploadRankData{
    
    //如果用户登录了，上传到云端，用户未登录，先暂存在本地
    if ([CurrentUserInfo sharedCurrentUserIfo].userID) {
        //用户已经登录，上传rank信息到云端
        [self uploadRankToCloud];
    }else{
        //用户未登录，信息暂存本地
        [self uploadRankToLocal];
    }
}

//上传rank信息到云端
- (void)uploadRankToCloud{
    //当前有用户登录
    AVUser *currentUser = [AVUser currentUser];
    
    if (currentUser) {
        
        //1.上传头像照片到_File,获得图片的url
        NSData *imageData = [CurrentUserInfo sharedCurrentUserIfo].headImage;
        AVFile *file = [AVFile fileWithName:@"headImage.png" data:imageData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                NSLog(@"上传头像成功%@",file.url);
                
                //2.RankData表插入一条新数据 {nickName,headImageURL,score}
                AVObject *rankData = [AVObject objectWithClassName:@"RankData"];
                [rankData setObject:file.url forKey:@"headImageURL"];
//                [rankData setObject:[CurrentUserInfo sharedCurrentUserIfo].nickname forKey:@"nickName"];
                [rankData setObject:[currentUser objectForKey:@"nickName"] forKey:@"nickName"];
                [rankData setObject:@([CurrentUserInfo sharedCurrentUserIfo].score) forKey:@"score"];
                
                //3.将rankdata和currentUser关联
                [rankData setObject:currentUser forKey:@"createdBy"];
                //保存rankData对象
//                NSLog(@"%ld",file.url.length);
                if (file.url.length) {
                    [rankData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"云端保存对象成功");
                        }
                    }];
                }
            }
        }];
 
    }else{
        NSLog(@"用户还未登录");
    }
    
    
}
//暂存rank信息到本地
- (void)uploadRankToLocal{
    //得到本地model
    UserDataModel *model = [[DataManager sharedManager] unArchiver];
    model.headImage = [CurrentUserInfo sharedCurrentUserIfo].headImage;
    model.nickName = [CurrentUserInfo sharedCurrentUserIfo].nickname;
    model.score = [CurrentUserInfo sharedCurrentUserIfo].score;
    //归档
    [[DataManager sharedManager] archiverWithUserData:model];
    
}

//更新rank信息
- (void)updateRankDataWithScore:(CGFloat)score{
    //得到当前对象的RankData对象
    AVQuery *rankDataQuery = [AVQuery queryWithClassName:@"RankData"];
    [rankDataQuery whereKey:@"createdBy" equalTo:[AVUser currentUser]];
    AVObject *rankData = [rankDataQuery getFirstObject];
    [rankData setObject:@(score) forKey:@"score"];
    [rankData setObject:[CurrentUserInfo sharedCurrentUserIfo].nickname forKey:@"nickName"];
    //更新对象
    [rankData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"更新成功");
        }
    }];

}



#pragma mark ----------------------- UIScrollViewDelegate -------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.y > 0){
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return reSizeImage;
    
}

#pragma mark --------------------- DataManagerDelegate ------------------------------
//清空数据
- (void)emptyLocalData{
    
    UserDataModel *model = [[DataManager sharedManager] unArchiver];
    [model.dayData removeAllObjects];
    [model.weekData removeAllObjects];
    [model.monthData removeAllObjects];
    model.actualCount = @(0);
    model.nicotineReduce = @(0);
    model.tarReduce = @(0);
    
    [[DataManager sharedManager] archiverWithUserData:model];
    
    [self createdFirstDataWithModel:model];
    [CurrentUserInfo sharedCurrentUserIfo].noSmokeDayNumber = 1;
    [CurrentUserInfo sharedCurrentUserIfo].actualNumber = 0;
    [CurrentUserInfo sharedCurrentUserIfo].headImage = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chageHeadImage" object:nil];
    NSLog(@"---------------%ld",[CurrentUserInfo sharedCurrentUserIfo].noSmokeDayNumber);
    
}
//更新新用户的数据
- (void)updateNewUserData{
    
    if ([self isRankDataExists]) {
        NSLog(@"本日已经吸烟数------%ld",[CurrentUserInfo sharedCurrentUserIfo].actualNumber);
        
        [CurrentUserInfo sharedCurrentUserIfo].score = 100 - [CurrentUserInfo sharedCurrentUserIfo].actualNumber*2;
        [self updateRankDataWithScore:[CurrentUserInfo sharedCurrentUserIfo].score];
    }else{
        [self uploadRankToCloud];
    }
   
}

- (void)uploadUserInfo{
    
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

@end
