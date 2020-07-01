//
//  VerifyCodeController.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyCodeController : BaseViewController
@property(nonatomic, copy)NSString *phoneNum;
-(instancetype)initWithPhoneNum:(NSString *)phoneNum;
@end
