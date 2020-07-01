//
//  VerifyCodeView.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeTFView : UIView
typedef void(^OnFinishedEnterCode)(NSString *code);

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode;

- (void)resetDefaultStatus;

- (void)codeBecomeFirstResponder;

@end
