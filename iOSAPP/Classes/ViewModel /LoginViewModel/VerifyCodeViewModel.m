//
//  VerifyCodeViewModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "VerifyCodeViewModel.h"
@interface VerifyCodeViewModel ()
@property(nonatomic, strong)VerifyCodeView *verifyCodeView;
@end
@implementation VerifyCodeViewModel
-(instancetype)initWithVerifyCodeView:(VerifyCodeView *)verifyCodeView{
    if ([super init]) {
        _verifyCodeView = verifyCodeView;
        @weakify(self);
        [_verifyCodeView.verifyCodeSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.codeString = x;
            [self.controller.view endEditing:YES];
            [self commitVerificationCode];
        }];
    }
    return self;
}

-(void)setController:(VerifyCodeController *)controller {
    _controller = controller;
    _phoneNum = _controller.phoneNum;
    NSString *phone = [self phoneNumFormat:_controller.phoneNum];
    _verifyCodeView.desLa.text = [NSString stringWithFormat:@"验证码已发送至 %@",phone];
    @weakify(self);
    [[_verifyCodeView.closeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
        @strongify(self)
        NSLog(@"------%@===我点击了按钮",sender);
        [self.controller.navigationController popViewControllerAnimated:YES];
    }];
    
    [[_verifyCodeView.authCodeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self reset];
        [self getVerificationCode];
    }];
    [self openCountdown];
}

-(void)getVerificationCode {
    __weak typeof(self) weakself = self;
    __block MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.controller.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [HttpClient getVerificationCode:self.phoneNum block:^(HttpResponse *response) {
        hud.mode = MBProgressHUDModeText;
        if (response.isSucess) {
            [weakself openCountdown];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"验证码已发送";
        } else {;
            // Set the text mode to show only text.
            hud.label.text = @"获取验证码失败";
        }
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, 0.f);
        [hud hideAnimated:YES afterDelay:2.f];
        
    }];
}

-(void)commitVerificationCode{
    
    __weak typeof(self) weakself = self;
    __block MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.controller.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [HttpClient loginWithPhoneNum:self.phoneNum code:self.codeString  block:^(HttpResponse *response) {
        if (response.isSucess) {
            [[Context get]initLogin:response.result];
            [[Context get]writeLoginAccount:response.result];
            [Context get].isLogin = YES;
            [[SocketClient get] connect:@"login"];
            [[Context get].loginSubject sendNext:@YES];
            [hud hideAnimated:YES];
            [weakself.controller.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"验证码填写错误";
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, 0.f);
            [hud hideAnimated:YES afterDelay:2.f];
            //                [[Context get].loginSubject sendNext:@NO];
            [weakself reset];
        }
    }];
}

- (void)reset {
    [_verifyCodeView.codeView resetDefaultStatus];
}
// 开启倒计时效果
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.verifyCodeView.authCodeBtn setTitle:@"重发短信验证码" forState:UIControlStateNormal];
                [self.verifyCodeView.authCodeBtn setTitleColor:[UIColor colorWithCSS:@"#2D89EF"] forState:UIControlStateNormal];
                self.verifyCodeView.authCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.verifyCodeView.authCodeBtn setTitle:[NSString stringWithFormat:@"%d 秒后可重新获取", seconds] forState:UIControlStateNormal];
                [self.verifyCodeView.authCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.verifyCodeView.authCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
}
-(NSString *)phoneNumFormat:(NSString *)string{
    NSMutableString *str = [[NSMutableString alloc] initWithString:string];
    [str insertString:@"-" atIndex:3];
    [str insertString:@"-" atIndex:8];
    return str;
}
@end
