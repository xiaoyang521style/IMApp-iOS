//
//  VerifyCodeView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "VerifyCodeView.h"

@implementation VerifyCodeView

-(instancetype)init {
    if ([super init]) {
        [self addSubviews];
        [self initSubject];
        
    }
    return self;
}
-(void)initSubject {
    self.verifyCodeSubject = [RACSubject subject];
}
-(void)addSubviews {
    __weak typeof(self) weakself = self;
    VerifyCodeTFView *codeView = [[VerifyCodeTFView alloc] initWithFrame:CGRectMake(0, StatusBarHeight +250, SCREEN_WIDTH, 50) onFinishedEnterCode:^(NSString *code) {
        [weakself.verifyCodeSubject sendNext:code];
    }];
    _codeView = codeView;
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLa];
    [self addSubview:self.desLa];
    [self addSubview:self.codeView];
    [self addSubview:self.authCodeBtn];
}
-(UIButton *)authCodeBtn {
    if (_authCodeBtn == nil) {
        _authCodeBtn = [[UIButton alloc]init];
        _authCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _authCodeBtn;
}
-(UILabel *)desLa {
    if (_desLa == nil) {
        _desLa = [[UILabel alloc]init];
        _desLa.font = [UIFont systemFontOfSize:18];
        _desLa.textColor = [UIColor darkGrayColor];
        _desLa.textAlignment = NSTextAlignmentCenter;
        
    }
    return _desLa;
}
-(UILabel *)titleLa {
    if (_titleLa == nil) {
        _titleLa = [[UILabel alloc]init];
        _titleLa.text = @"请输入验证码";
        _titleLa.font = [UIFont boldSystemFontOfSize:35];
    }
    return _titleLa;
}
-(UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc]init];
        UIImage *image = [UIImage imageWithFont:ic_arrow_left  size:27 color:[UIColor darkGrayColor]];
        [_closeBtn setImage:image forState:UIControlStateNormal];
    }
    return _closeBtn;
}

-(void)layoutSubviews {
    __weak typeof(self) weakself = self;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.top.equalTo(weakself).with.offset(StatusBarHeight);
    }];
    [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(35);
        make.right.equalTo(weakself).offset(-30);
        make.height.mas_equalTo(@35);
        make.top.equalTo(weakself.closeBtn.mas_bottom).offset(30);
        
    }];
    [self.desLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLa);
        make.left.right.equalTo(weakself).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(@30);
        make.top.equalTo(weakself.titleLa.mas_bottom).offset(45);
    }];
    [self.authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150,30));
        make.centerX.equalTo(self.desLa);
        make.top.equalTo(self.codeView.mas_bottom).offset(40);
    }];
    
}

@end
