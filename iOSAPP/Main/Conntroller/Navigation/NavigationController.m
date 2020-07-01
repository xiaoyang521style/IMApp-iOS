//
//  NavigationController.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "NavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface NavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong, nullable) UIActivityIndicatorView *indicatorView;
@property (nonatomic, copy) NSString *oldTitle;
@end

@implementation NavigationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    
    // 灰色菊花
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self.navigationBar addSubview:self.indicatorView];
    
    NotificationCenterAddObserver(self, @selector(sockStatus:), NOTIFICATION_SOCK_STATUS, nil);
    
}
-(void)sockStatus:(NSNotification *)notif {
    SOCK_STATUS status = [notif.object intValue];
    switch (status) {
        case SKStatusUnknow:
            self.animate = NO;
            break;
        case SKStatusConnecting:
            self.animate = YES;
            break;
        case SKStatusConnected:
            self.title = self.oldTitle;
            self.animate = NO;
            break;
        case SKStatusDidDisconnected:
            self.animate = NO;
            break;
        default:
            break;
    }
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count < 1) {
        return NO;
    }else{
        return YES;
    }
}

// 重写自定义的UINavigationController中的push方法
// 处理tabbar的显示隐藏
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 进入新页面，title长度变化后，重新调整菊花位置
    // Xcode 9编辑器，请用如下代码，兼容iOS8-iOS11
    for (UIView *subView in self.navigationBar.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"_UINavigationBarContentView"]) {
            for (UIView *sub in subView.subviews) {
                if ([sub isKindOfClass:[UILabel class]] && [[sub valueForKey:@"text"] isEqualToString:self.viewControllers.lastObject.title]) {
                    self.indicatorView.frame = CGRectMake(sub.frame.origin.x - 30, 0, 30, 30);
                    self.indicatorView.center = CGPointMake(self.indicatorView.center.x, sub.center.y);
                }
            }
        } else if ([NSStringFromClass([subView class]) isEqualToString:@"UINavigationItemView"]) {
            if ([[subView valueForKey:@"title"] isEqualToString:[self.viewControllers lastObject].title]) {
                self.indicatorView.frame = CGRectMake(subView.frame.origin.x - 30, 0, 30, 30);
                self.indicatorView.center = CGPointMake(self.indicatorView.center.x, subView.center.y);
            }
        }
    }
    // Xcode 8及以下编辑器，请用如下代码，兼容iOS8-iOS11
    for (UIView *subView in self.navigationBar.subviews) {
        if ([NSStringFromClass([subView class]) containsString:@"UINavigationItemView"]) {
            if ([[subView valueForKey:@"title"] isEqualToString:[self.viewControllers lastObject].title]) {
                self.indicatorView.frame = CGRectMake(subView.frame.origin.x - 30, 0, 30, 30);
                self.indicatorView.center = CGPointMake(self.indicatorView.center.x, subView.center.y);
            }
        }
    }
}
- (void)setAnimate:(BOOL)animate {
    _animate = animate;
    if (animate) {
        [self.indicatorView startAnimating];
    } else {
        [self.indicatorView stopAnimating];
    }
}

@end
