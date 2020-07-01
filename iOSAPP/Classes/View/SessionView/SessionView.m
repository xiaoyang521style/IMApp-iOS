//
//  SessionView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/28.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SessionView.h"

@interface SessionView()
@property(nonatomic,strong)SessionController *controller;
@end

@implementation SessionView

-(instancetype)init {
    if ([super init]) {
        [self addSubview:self.tableView];
    }
    return self;
}
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.contentInset = UIEdgeInsetsMake(StatusBarAndNavigationBarHeight, 0, TabbarHeight, 0);
        _tableView.separatorInset = UIEdgeInsetsMake(StatusBarAndNavigationBarHeight, 0, TabbarHeight, 0);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
           
        }
    }
    return _tableView;
}
-(void)layoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
@end
