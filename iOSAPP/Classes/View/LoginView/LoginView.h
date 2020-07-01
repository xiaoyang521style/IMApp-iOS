//
//  LoginView.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LoginBtnEnableColor [UIColor colorWithCSS:@"#90D0FF"]
#define LoginBtnNormalColor [UIColor colorWithCSS:@"#2D89EF"]

#define LoginBtnEnableTitleColor  [UIColor lightGrayColor]
#define LoginBtnNormalTitleColor  [UIColor colorWithCSS:@"#FFFFFF"]

@interface LoginView : UIView
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UILabel *titleLa;
@property(nonatomic, strong) UITextField *phoneNumTF;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UILabel *bottomLa;
@property(nonatomic, strong) NSString *phoneNum;
@property(nonatomic, strong) RACSubject *closeSubject;
@property(nonatomic, strong) RACSubject *loginSubject;
-(void)showKeyboard;
@end
