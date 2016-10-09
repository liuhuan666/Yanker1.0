//
//  UITableView+EmptyData.h
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/12.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (NSInteger)showMessage:(NSString *)message byDataSourceCount:(NSInteger)count;

@end
