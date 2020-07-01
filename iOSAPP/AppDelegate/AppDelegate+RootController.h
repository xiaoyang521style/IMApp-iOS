//
//  AppDelegate+RootController.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/11.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "TabBarViewController.h"
#import "LeftDrawerController.h"
#import "DrawerVisualStateManager.h"
#import <QuartzCore/QuartzCore.h>
@interface AppDelegate (RootController)
@property(nonatomic, strong)MMDrawerController *drawerController;
@property(nonatomic, strong) TabBarViewController *centerController;
@property(nonatomic, strong) LeftDrawerController *leftDrawerController;
-(void)setRootController;
@end
