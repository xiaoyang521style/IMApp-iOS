//
//  EmptyView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

+ (instancetype)diyEmptyView{
    
    return [EmptyView emptyViewWithImageStr:@"noData"
                                       titleStr:@"暂无数据"
                                      detailStr:@"请稍后再试!"];
}

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action{
    
    return [EmptyView emptyActionViewWithImageStr:@"noNetwork"
                                             titleStr:@"无网络连接"
                                            detailStr:@"请检查你的网络连接是否正确!"
                                          btnTitleStr:@"重新加载"
                                               target:target
                                               action:action];
}

- (void)prepare{
    [super prepare];
    self.autoShowEmptyView = NO;
}

@end
