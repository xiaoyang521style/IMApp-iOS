//
//  VerifyCodeView.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyCodeTFView.h"
@interface VerifyCodeView : UIView
@property (nonatomic, weak) VerifyCodeTFView *codeView;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UILabel *titleLa;
@property(nonatomic, strong) UILabel *desLa;
@property(nonatomic, strong) UIButton *authCodeBtn;
@property(nonatomic, strong) RACSubject *verifyCodeSubject;
@end
