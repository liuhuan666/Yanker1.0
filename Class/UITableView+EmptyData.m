//
//  UITableView+EmptyData.m
//  Yanker1.0
//
//  Created by Guo Nice on 16/5/12.
//  Copyright © 2016年 Bathroom. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

- (NSInteger)showMessage:(NSString *)message byDataSourceCount:(NSInteger)count{
    
    if (count == 0) {
        
        
        self.backgroundView = ({
            
            UILabel *label = [[UILabel alloc] init];
            label.text = message;
            label.textAlignment = NSTextAlignmentCenter;
            label;
            
        });
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }else{
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    
    
    return count;
}
@end
