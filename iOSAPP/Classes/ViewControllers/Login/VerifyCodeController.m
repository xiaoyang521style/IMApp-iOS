//
//  VerifyCodeController.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "VerifyCodeController.h"
#import "VerifyCodeView.h"
#import "VerifyCodeViewModel.h"

#import "VerifyCodeTFView.h"
#import "UIView+MBLayout.h"
@interface VerifyCodeController ()
@property(nonatomic, strong)VerifyCodeView *verifyCodeView;
@property(nonatomic, strong) VerifyCodeViewModel *verifyCodeViewModel;
@end

@implementation VerifyCodeController
-(instancetype)initWithPhoneNum:(NSString *)phoneNum {
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self setupUI];
  
    self.verifyCodeViewModel = [[VerifyCodeViewModel alloc]initWithVerifyCodeView:self.verifyCodeView];
    self.verifyCodeViewModel.controller = self;
}

-(void)setupUI {
    [self.view addSubview:self.verifyCodeView];
    __weak typeof(self) weakself = self;
    [self.verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(VerifyCodeView *)verifyCodeView {
    if (_verifyCodeView == nil) {
        _verifyCodeView = [[VerifyCodeView alloc]init];
    }
    return _verifyCodeView;
}
                    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
