//
//  TabBarViewController.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/26.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "TabBarViewController.h"
#import "SessionController.h"
#import "ContactsController.h"
#import "StatusController.h"
#import "ProfileController.h"
#import "PPBadgeView.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIViewController* sessionVC = [[SessionController alloc] init];
    sessionVC.navigationItem.title = @"Hey";
    NavigationController *sessionNav = [[NavigationController alloc] initWithRootViewController:sessionVC];
    sessionNav.tabBarItem.image = [UIImage imageNamed:@"icon_chat"];
    sessionNav.tabBarItem.title = @"Hey";
    [self addChildViewController:sessionNav];
    
    UIViewController* contactsVC = [[ContactsController alloc] init];
    contactsVC.navigationItem.title = @"通讯录";
    NavigationController *contactsNav = [[NavigationController alloc] initWithRootViewController:contactsVC];
    contactsNav.tabBarItem.image = [UIImage imageNamed:@"icon_contact"];
    contactsNav.tabBarItem.title = @"通讯录";
    [self addChildViewController:contactsNav];
    
    UIViewController *statusVC = [[StatusController alloc] initWithFromMyStatus:NO];
    statusVC.navigationItem.title = @"动态";
    NavigationController *statusNav = [[NavigationController alloc] initWithRootViewController:statusVC];
    statusNav.tabBarItem.image = [UIImage imageNamed:@"icon_status"];
    statusNav.tabBarItem.title = @"动态";
    [self addChildViewController:statusNav];
    
    UIViewController* profileVC = [[ProfileController alloc] init];
    profileVC.navigationItem.title = @"我";
    NavigationController *profileNav = [[NavigationController alloc] initWithRootViewController:profileVC];
    profileNav.tabBarItem.title = @"我";
    profileNav.tabBarItem.image = [UIImage imageNamed:@"icon_me"];
    [self addChildViewController:profileNav];
    
    if (@available(iOS 10.0, *)) {
        [self.tabBar setTintColor:[UIColor colorWithHex:@"0x4990E2"]];
        [self.tabBar setUnselectedItemTintColor:[UIColor colorWithHex:@"0xCCC9CD"]];
    } else {

        // 未选中时
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"0xCCC9CD"];
        
        // 选中时字体颜色和选中图片颜色一致
        NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
        selectedTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
        selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"0x4990E2"];
        
        // 通过appearance统一设置所有UITabBarItem的文字属性样式
        UITabBarItem *item = [UITabBarItem appearance];
        [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
        // Fallback on earlier versions
    }
    
     [RACObserve([Context get], unreadMessageCount) subscribeNext:^(id x) {
         if ([Context get].unreadMessageCount == 0) {
             [sessionNav.tabBarItem pp_hiddenBadge];
         }else{
             [sessionNav.tabBarItem pp_showBadge];
             if ([Context get].unreadMessageCount > 99) {
                 [sessionNav.tabBarItem pp_addBadgeWithText:@"99+"];
             }else{
                 [sessionNav.tabBarItem pp_addBadgeWithText:[NSString stringWithFormat:@"%d",[Context get].unreadMessageCount]];
             }
         }
    
     }];
   
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
