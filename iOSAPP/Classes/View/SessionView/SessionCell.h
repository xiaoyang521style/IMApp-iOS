//
//  SessionCell.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/28.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionModel.h"
#import "PPBadgeView.h"
@interface SessionCell : UITableViewCell
@property(nonatomic, strong)SessionModel *model;
@property (strong, nonatomic)PPBadgeLabel *badgeLabel;
@end
