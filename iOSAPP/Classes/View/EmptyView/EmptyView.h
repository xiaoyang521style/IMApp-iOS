//
//  EmptyView.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "LYEmptyView.h"

@interface EmptyView : LYEmptyView
+ (instancetype)diyEmptyView;

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action;

@end
