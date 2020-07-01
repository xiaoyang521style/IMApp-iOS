
//
//  LoginViewModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "LoginViewModel.h"
#import "VerifyCodeController.h"
@interface LoginViewModel()
@property(nonatomic, strong)LoginView *loginView;
@end

@implementation LoginViewModel
-(instancetype)initWithView:(LoginView *)loginView{
    if ([super init]) {
        _loginView = loginView;
        [self initSubject];
        [self initSignal];
    }
    return self;
}

-(void)initSignal{
    @weakify(self);
    [[self.loginView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.loginView.closeSubject sendNext:nil];
    }];
    RACSignal *phoneNumSignal = [self.loginView.phoneNumTF.rac_textSignal map:^id(id value) {
        @strongify(self)
        NSArray *arr = [value componentsSeparatedByString:@"-"];
        self.loginView.phoneNum =[arr componentsJoinedByString:@""];
        return @([self isValidPhoneNum:self.loginView.phoneNum]);
    }];
    
    RACSignal *loginSignal = [RACSignal combineLatest:@[phoneNumSignal] reduce:^id (NSNumber *phoneNumValue){
        return @([phoneNumValue boolValue]);
    }];
    [loginSignal subscribeNext:^(id boolValue) {
        @strongify(self)
        if ([boolValue boolValue]) {
            self.loginView.loginBtn.userInteractionEnabled = YES;
            [self.loginView.loginBtn setBackgroundColor:LoginBtnNormalColor];
        }else{
            self.loginView.loginBtn.userInteractionEnabled = NO;
            [self.loginView.loginBtn setBackgroundColor:LoginBtnEnableColor];
        }
    }];
    [[self.loginView.loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
        @strongify(self)
        [self.loginView.loginSubject sendNext:self.loginView.phoneNum];
    }];
}
-(void)initSubject {
    self.loginView.closeSubject = [RACSubject subject];
    self.loginView.loginSubject = [RACSubject subject];
}

// 验证手机
- (BOOL)isValidPhoneNum:(NSString *)phoneNum {
    // 验证用户名 - 手机号码
    NSString *regEx = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [phoneTest evaluateWithObject:phoneNum];
}

-(void)setController:(LoginController *)controller {
    _controller = controller;
    @weakify(self);
    [self.loginView.closeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.controller.view endEditing:YES];
        [self.controller closeController];
    }];
    [self.loginView.loginSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.phoneNum = x;
        [self.controller.view endEditing:YES];
        [self getVerificationCode];
    }];
}

-(void)getVerificationCode {
    __weak typeof(self) weakself = self;
    __block MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.controller.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [HttpClient getVerificationCode:self.phoneNum block:^(HttpResponse *response) {
        if (response.isSucess) {
            [hud hideAnimated:YES];
            VerifyCodeController *verifyCodeVC = [[VerifyCodeController alloc]initWithPhoneNum:weakself.phoneNum];
            [weakself.controller.navigationController pushViewController:verifyCodeVC animated:YES];
        } else {;
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"获取验证码失败";
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, 0.f);
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }];
}
@end
