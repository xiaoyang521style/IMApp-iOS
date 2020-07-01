//
//  LoginView.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//



#import "LoginView.h"

@interface LoginView()<UITextFieldDelegate>

@end

@implementation LoginView

-(instancetype)init {
    if ([super init]) {
        [self addSubviews];

    }
    return self;
}

-(void)addSubviews {
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLa];
    [self addSubview:self.phoneNumTF];
    [self addSubview:self.loginBtn];
    [self addSubview:self.bottomLa];
}
-(UIButton *)loginBtn {
    if (_loginBtn==nil) {
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:LoginBtnNormalTitleColor forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.enabled = YES;
    }
    return _loginBtn;
}
-(UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc]init];
        UIImage *image = [UIImage imageWithFont:ic_colse  size:27 color:[UIColor darkGrayColor]];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}

-(UILabel *)titleLa {
    if (_titleLa == nil) {
        _titleLa = [[UILabel alloc]init];
        _titleLa.text = @"登录";
        _titleLa.font = [UIFont boldSystemFontOfSize:35];
    }
    return _titleLa;
}
-(UILabel *)bottomLa {
    if (_bottomLa == nil) {
        _bottomLa = [[UILabel alloc]init];
        _bottomLa.text = @"手机验证后自动登录";
        _bottomLa.font = [UIFont systemFontOfSize:15];
        _bottomLa.textColor = [UIColor grayColor];
        _bottomLa.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLa;
}
-(UITextField *)phoneNumTF {
    if (_phoneNumTF == nil) {
        _phoneNumTF = [[UITextField alloc]init];
        _phoneNumTF.font = [UIFont systemFontOfSize:17];
        _phoneNumTF.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumTF.layer.borderWidth = 1;
        _phoneNumTF.placeholder = @"手机号码";
        _phoneNumTF.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        [_phoneNumTF.layer setCornerRadius:3.0];
        _phoneNumTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTF.delegate = self;
    }
    return _phoneNumTF;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    __weak typeof(self) weakself = self;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.top.equalTo(weakself).with.offset(StatusBarHeight);
    }];
    [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakself.closeBtn.mas_left);
        make.left.equalTo(weakself.mas_left).offset(35);
        make.size.mas_equalTo(CGSizeMake(80, 35));
        make.top.equalTo(weakself.closeBtn.mas_bottom).offset(25);
    }];
    [self.phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself).insets(UIEdgeInsetsMake(0, 35, 0, 35 ));
        make.top.equalTo(weakself.titleLa.mas_bottom).offset(70);
        make.height.equalTo(@45);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself).insets(UIEdgeInsetsMake(0, 35, 0, 35));
        make.top.equalTo(weakself.phoneNumTF.mas_bottom).offset(40);
        make.height.equalTo(@40);
    }];
    [self.bottomLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself).insets(UIEdgeInsetsMake(0, 35, 0, 35));
        make.top.equalTo(weakself.loginBtn.mas_bottom).offset(30);
        make.height.equalTo(@30);
    }];
}

-(void)showKeyboard {
    [self.phoneNumTF becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (range.location == 13) {
        return NO;
    }else if (range.location == 8){
        NSMutableString *str = [[NSMutableString alloc] initWithString:_phoneNumTF.text];
        NSRange range = [str rangeOfString:@"-"];
        if (range.location!=NSNotFound)
        {
            
        } else {
            [str insertString:@"-" atIndex:3];
            [str insertString:@"-" atIndex:8];
            _phoneNumTF.text = str;
        }
        return YES;
    }else if(range.location==9) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:_phoneNumTF.text];
        NSString *str1;
        str1 = [str stringByReplacingOccurrencesOfString:@"-"withString:@""];
        _phoneNumTF.text = str1;
        return YES;
    }else
    {
        return YES;
    }
}
@end
