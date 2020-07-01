//
//  SessionController.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/26.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SessionController.h"
#import "SessionView.h"
#import "SessionViewModel.h"
@interface SessionController ()
@property(nonatomic, strong)SessionView *sessionView;
@property(nonatomic, strong)SessionViewModel *viewmodel;
@end

@implementation SessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sessionView];
    [self.sessionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));;
    }];
    self.viewmodel = [[SessionViewModel alloc]initView:self.sessionView controller:self];

}
-(SessionView *)sessionView {
    if (_sessionView == nil) {
        _sessionView = [[SessionView alloc]init];
    }
    return _sessionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
