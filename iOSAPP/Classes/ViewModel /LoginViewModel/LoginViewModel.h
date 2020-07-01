//
//  LoginViewModel.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginView.h"
#import "LoginController.h"

@interface LoginViewModel : NSObject
-(instancetype)initWithView:(LoginView *)loginView;
@property(nonatomic, strong)LoginController *controller;
@property(nonatomic, copy)NSString *phoneNum;
@end
