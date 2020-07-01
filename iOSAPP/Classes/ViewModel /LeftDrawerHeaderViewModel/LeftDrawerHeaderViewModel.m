//
//  LeftDrawerHeaderViewModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "LeftDrawerHeaderViewModel.h"

@implementation LeftDrawerHeaderViewModel
-(instancetype)init {
    if ([super init]) {
        
    }
    return self;
}
-(void)setHeaderView:(LeftDrawerHeaderView *)headerView {
    _headerView = headerView;
    @weakify(self);
    [[Context get].loginSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self loginSucess];
        }else{
      
        }
        NSLog(@"%@",x);
    }];
    [[Context get].logoutSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        @strongify(self)
    
    }];
    [[_headerView.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[Navigator get] presentLoginVC];
    }];
    [self.headerView.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Context get].icon] placeholderImage:[UIImage imageNamed:@"IMG_2683.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    self.headerView.loginBtn.hidden = YES;
    self.headerView.nameLa.hidden = NO;
    self.headerView.nameLa.text = [Context get].username;
}
-(void)loginSucess {
 
}

@end
