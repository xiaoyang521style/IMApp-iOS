//
//  LoginController.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "LoginViewModel.h"
@interface LoginController ()
@property(nonatomic, strong)LoginViewModel *loginViewModel;
@property(nonatomic, strong)LoginView *loginView;
@property(nonatomic, copy)NSString *phoneNum;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.fd_prefersNavigationBarHidden = YES;
    _loginViewModel = [[LoginViewModel alloc]initWithView:self.loginView];
    _loginViewModel.controller = self;
}

-(void)setupUI {
    [self.view addSubview:self.loginView];
     __weak typeof(self) weakself = self;
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(LoginView *)loginView {
    if (_loginView == nil) {
        _loginView = [[LoginView alloc]init];
    }
    return _loginView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.loginView showKeyboard];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
