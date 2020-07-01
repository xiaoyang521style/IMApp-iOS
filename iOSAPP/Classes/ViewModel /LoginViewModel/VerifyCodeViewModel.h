//
//  VerifyCodeViewModel.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyCodeView.h"
#import "VerifyCodeController.h"
@interface VerifyCodeViewModel : NSObject
-(instancetype)initWithVerifyCodeView:(VerifyCodeView *)verifyCodeView;
@property(nonatomic, strong)VerifyCodeController *controller;
@property(nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy) NSString *codeString;
@end
