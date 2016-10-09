//
//  DataStatisticsViewController.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/5.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "DataStatisticsViewController.h"
#import "LewBarChart.h"
#import "TipViewController.h"

@interface DataStatisticsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) LewBarChart *dayBarChart;//每日数据图表
@property (strong, nonatomic) LewBarChart *weekBarChart;//每周数据图表
@property (strong, nonatomic) LewBarChart *monthBarChart;//每月数据图表
@property (weak, nonatomic) IBOutlet UIView *chartbg_1;//图表背景图
@property (weak, nonatomic) IBOutlet UIView *chartbg_2;
@property (weak, nonatomic) IBOutlet UIView *chartbg_3;
@property (weak, nonatomic) IBOutlet UIView *chartbg_4;

@property (weak, nonatomic) IBOutlet UILabel *totalDaysLabel;//使用天数
@property (weak, nonatomic) IBOutlet UILabel *smokeAmount;//抽烟数目
@property (weak, nonatomic) IBOutlet UILabel *nicotineLabel;//尼古丁量
@property (weak, nonatomic) IBOutlet UILabel *tarLabel;//焦油量

@property (strong, nonatomic) NSMutableArray *daysDataSource;//当日数据源
@property (strong, nonatomic) NSMutableArray *weekDataSource;//每周数据源
@property (strong, nonatomic) NSMutableArray *monthDataSource;//每月数据源


@end

@implementation DataStatisticsViewController
#pragma mark -- 属性懒加载
- (NSMutableArray *)daysDataSource{
    if (!_daysDataSource) {
        _daysDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _daysDataSource;
}
- (NSMutableArray *)weekDataSource{
    if (!_weekDataSource) {
        _weekDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _weekDataSource;
}
- (NSMutableArray *)monthDataSource{
    if (!_monthDataSource) {
        _monthDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _monthDataSource;
}
- (void)creatPlaceHoldeData{
    for (int i = 0; i < 7; i++) {
        [self.weekDataSource addObject:@(0)];
    }
    for (int i = 0; i < 24; i++) {
        [self.daysDataSource addObject:@(0)];
    }
    for (int i = 0; i < 30; i++) {
        [self.monthDataSource addObject:@(0)];
    }
}


#pragma mark -- 视图生命周期
- (void)viewWillAppear:(BOOL)animated{

    self.scrollView.contentOffset = CGPointMake(0, 0);
    if (self.dayBarChart) {
        [self.dayBarChart removeFromSuperview];
        [self.weekBarChart removeFromSuperview];
        [self.monthBarChart removeFromSuperview];
        self.dayBarChart = nil;
        self.weekBarChart = nil;
        self.monthBarChart = nil;
    }
    
    if (self.daysDataSource) {
        [self.daysDataSource removeAllObjects];
        [self.weekDataSource removeAllObjects];
        [self.monthDataSource removeAllObjects];
    }
    [self creatPlaceHoldeData];
    [self classifyDayData];
    [self addChart];
    
    NSLog(@"count ==== %ld",self.daysDataSource.count);
}

- (void)viewDidLoad{
    [super viewDidLoad];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize: 17],NSFontAttributeName, nil];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self adjustTextSize];
    NSLog(@"%@",NSStringFromCGPoint(self.scrollView.contentOffset));
   
}

- (void)didReceiveMemoryWarning{
    
}
#pragma mark --设置每种图表

- (void)addChart{

    NSLog(@"day_count = %ld",self.daysDataSource.count);
    NSLog(@"week_count = %ld",self.weekDataSource.count);
    NSLog(@"month_count = %ld",self.monthDataSource.count);
 
    
   self.dayBarChart =  [self createBarchartWithDataArray:self.daysDataSource
                              xLabels:@[@"凌晨12时",@"下午12时",@"晚上19时"]
                          description:[self maxOfArray:self.daysDataSource]
                               bgView:self.chartbg_1
                                space:5];
    
   self.weekBarChart =  [self createBarchartWithDataArray:self.weekDataSource
                              xLabels:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]
                          description:[self maxOfArray:self.weekDataSource]
                               bgView:self.chartbg_2
                                space:5];
    
   self.monthBarChart =  [self createBarchartWithDataArray:self.monthDataSource
                              xLabels:@[@"1",@"7",@"14",@"21",@"28"]
                          description:[self maxOfArray:self.monthDataSource]
                               bgView:self.chartbg_3
                                space:5];
    
    self.totalDaysLabel.text = [NSString stringWithFormat:@"%ld 天",[CurrentUserInfo sharedCurrentUserIfo].noSmokeDayNumber];
    
    self.smokeAmount.text = [NSString stringWithFormat:@"%ld 根",[[DataManager sharedManager] unArchiver].actualCount.integerValue];
    self.nicotineLabel.text = [NSString stringWithFormat:@"%.2f mg",[[DataManager sharedManager] unArchiver].nicotineReduce.floatValue];
    self.tarLabel.text = [NSString stringWithFormat:@"%.2f mg",[[DataManager sharedManager] unArchiver].tarReduce.floatValue];
}

//创建图表
- (LewBarChart *)createBarchartWithDataArray:(NSArray *)dataArray
                                     xLabels:(NSArray *)xLabels
                                 description:(NSString *)desc
                                      bgView:(UIView *)bgView
                                       space:(CGFloat)space{
    
   
    LewBarChart *barChart = [[LewBarChart alloc] initWithFrame:CGRectMake(5, 15, kWidth-kWidth/10  , kHeight/3-10)];
    LewBarChartDataSet *dataSet = [[LewBarChartDataSet alloc] initWithYValues:dataArray label:desc];

    [dataSet setBarColor:[UIColor lightGrayColor]];
    
    NSArray *setArray = @[dataSet];
    LewBarChartData *data = [[LewBarChartData alloc] initWithDataSets:setArray];
    data.xLabels = xLabels;
    data.itemSpace = space;
    
    barChart.data = data;
    barChart.displayAnimated = YES;
    barChart.chartMargin = UIEdgeInsetsMake(0, 0, 40, 0);
    barChart.showYAxis = YES;
    barChart.showXAxis = YES;
    barChart.showNumber = YES;
    barChart.legendView.alignment = LegendAlignmentHorizontal;
    [bgView addSubview:barChart];
    [barChart show];
    barChart.legendView.frame = CGRectMake(0, 0, 100, 30);
    barChart.legendView.center = CGPointMake(kWidth-80, -18);
    return barChart;
}
//label字体自适应大小
- (void)adjustTextSize{
    self.totalDaysLabel.adjustsFontSizeToFitWidth = YES;
    self.smokeAmount.adjustsFontSizeToFitWidth = YES;
    self.nicotineLabel.adjustsFontSizeToFitWidth = YES;
    self.tarLabel.adjustsFontSizeToFitWidth = YES;
}
- (NSArray *)timeAnalyze{
    NSArray *timeArray = [[[DataManager sharedManager] unArchiver].dayData allKeys];
    NSLog(@"time = %@",timeArray);
    NSMutableArray *hourArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *string in timeArray) {
        NSString *subString = [string substringWithRange:NSMakeRange(8, 2)];
        [hourArray addObject :@(subString.integerValue)];
    }
    return hourArray;
}



#pragma mark -- 控件回调方法
//小提示
- (IBAction)tipsAction:(UIButton *)sender {
    NSLog(@"%@",NSStringFromCGRect(sender.frame));
    TipViewController *tipVC = [[TipViewController alloc] initWithNibName:@"TipViewController" bundle:nil];
    [self.navigationController pushViewController:tipVC animated:YES];
    
}
- (void)dismissTipView:(UITapGestureRecognizer *)tap{
 
}

//数据分类
- (void)classifyDayData{

    NSMutableArray *dayData = [[self timeAnalyze] mutableCopy];
    for (NSNumber *index in dayData) {
        NSNumber *count = self.daysDataSource[index.integerValue];
        count = @(count.integerValue + 1);
        [self.daysDataSource replaceObjectAtIndex:index.integerValue withObject:count];

    }
    
    
    self.weekDataSource = [[DataManager sharedManager] unArchiver].weekData;
    self.monthDataSource = [[DataManager sharedManager] unArchiver].monthData;
    
    if (self.weekDataSource.count < 7) {
        for (int i = 0; i < 7 - self.weekDataSource.count; i++) {
            [self.weekDataSource addObject:@(0)];
        }
    }
    
    if (self.monthDataSource.count < 30) {
        for (int i = 0; i < 30 - self.monthDataSource.count; i++) {
            [self.monthDataSource addObject:@(0)];
        }
    }
}

//找出每组数据的最大值
- (NSString *)maxOfArray:(NSArray *)array{
    
    NSInteger max = [array.firstObject integerValue];
    for (int i = 0; i < array.count; i++) {
        max = max > [array[i] integerValue]?max:[array[i] integerValue];
    }
    return [NSString stringWithFormat:@"MAX : %ld ",max];
}






@end
