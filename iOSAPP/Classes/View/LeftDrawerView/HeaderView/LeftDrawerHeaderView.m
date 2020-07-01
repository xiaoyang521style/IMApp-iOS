//
//  LeftDrawerHeaderView.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/11.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "LeftDrawerHeaderView.h"
#import "XPFWaterWaveView.h"
#import "LeftDrawerHeaderViewModel.h"
#define  imgVH  60

@interface LeftDrawerHeaderView(){
    XPFWaterWaveView *_waveView;
    LeftDrawerHeaderViewModel *_leftDrawerHeaderViewModel;
}
@end
@implementation LeftDrawerHeaderView

-(instancetype)init {
    if ([super init]) {
        self.userInteractionEnabled  = YES;
    }
    return self;
}
-(void)drawRect:(CGRect)rect {
    [self addSubviews];
    _leftDrawerHeaderViewModel = [[LeftDrawerHeaderViewModel alloc]init];
    _leftDrawerHeaderViewModel.headerView = self;
}
-(UILabel *)nameLa {
    if (_nameLa == nil) {
        _nameLa = [[UILabel alloc]init];
        _nameLa.hidden = YES;
        _nameLa.textColor = [UIColor whiteColor];
        _nameLa.font = [UIFont boldSystemFontOfSize:22];
        _nameLa.frame = CGRectMake(15, CGRectGetHeight(self.frame)/2 - 15, CGRectGetMinX(self.iconImgView.frame) - 15, 30);
        [_nameLa setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return _nameLa;
}
-(UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.frame = CGRectMake(15, CGRectGetHeight(self.frame)/2 - 15, 90, 30);
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_loginBtn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return _loginBtn;
}
-(UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.frame = CGRectMake(self.bounds.size.width - imgVH  -20, CGRectGetHeight(self.frame)/2 - imgVH/2, imgVH, imgVH);
        _iconImgView.image = [UIImage imageNamed:@"IMG_2683.jpg"];
        _iconImgView.layer.cornerRadius = imgVH * 0.4;
        _iconImgView.layer.masksToBounds = YES;
        [_iconImgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return _iconImgView;
}
-(void)addSubviews{
    _waveView = [[XPFWaterWaveView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_waveView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _waveView.userInteractionEnabled = YES;
    [self addSubview:_waveView];
    //头像 姓名
    [self addSubview:self.iconImgView];
    [self addSubview:self.loginBtn];
    [self addSubview:self.nameLa];
    
}
-(void)layoutSubviews {
    
}
@end
