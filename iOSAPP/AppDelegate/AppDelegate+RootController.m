//
//  AppDelegate+RootController.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/11.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#define LeftNavigationControllerRestorationKey @"LeftNavigationControllerRestorationKey"
#define DrawerControllerRestorationKey @"DrawerControllerRestorationKey"
#define CenterControllerRestorationKey @"CenterControllerRestorationKey"
#define LeftSideDrawerControllerRestorationKey @"LeftSideDrawerControllerRestorationKey"
#import "AppDelegate+RootController.h"
#import <objc/runtime.h>
#import "LoginController.h"
#import "VerifyCodeController.h"
#import "TabBarViewController.h"
#import "ChatMessageTableViewController.h"
static char *CenterControllerKey = "CenterControllerKey";
static char *DrawerControllerKey = "DrawerControllerKey";
static char *LeftDrawerControllerKey= "LeftDrawerControllerKey";
@implementation AppDelegate (RootController)
-(void)setRootController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    [self.window setTintColor:tintColor];
    static UIViewController *contoller;
    if(DEBUGMODE){
        contoller = [self launch:DEBUGVIEW];
        if (DEBUGVIEW == 8) {
            [self.window setRootViewController:[[Navigator get]initWithRootViewController:contoller]];
        }else{
            NavigationController *navigationController = [[NavigationController alloc]initWithRootViewController:contoller];
            [self.window setRootViewController:navigationController];
        }
    }else{
         contoller = [self launch:8];
         [self.window setRootViewController:[[Navigator get]initWithRootViewController:contoller]];
    }

}
-(UIViewController *)setDrawerController{
    TabBarViewController *centerController =  [[TabBarViewController alloc]init];
    self.centerController = centerController;
    [self.centerController setRestorationIdentifier:CenterControllerRestorationKey];
    
    LeftDrawerController *leftDrawerController =  [[LeftDrawerController alloc]init];
    self.leftDrawerController = leftDrawerController;
    [self.leftDrawerController setRestorationIdentifier:LeftSideDrawerControllerRestorationKey];
    
    NavigationController * leftSideNavController = [[NavigationController alloc] initWithRootViewController:self.leftDrawerController];
    [leftSideNavController setRestorationIdentifier:LeftNavigationControllerRestorationKey];
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:self.centerController leftDrawerViewController:leftSideNavController];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:DrawerControllerRestorationKey];
    [self.drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width - 64];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[DrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    [DrawerVisualStateManager setCloseGesture:self.drawerController];
    [DrawerVisualStateManager setOpenGesture:self.drawerController];
    return self.drawerController;
}
- (UIViewController *)launch:(NSInteger)viewIndex {
    UIViewController *controller = nil;
    switch (viewIndex) {
            case 9:
            
            break;
            
            case 8:{
                if ([Context get].isLogin) {
                    controller = [self setDrawerController];
                }else{
                    controller = [self launch:1];
                }
               
            }
            
            break;
            case 7:
            
            break;
            case 6:
            
            break;
            case 5:
            
            break;
            case 4:
            
            break;
        case 3:{
            
            ChatMessageTableViewController *chatVC = [[ChatMessageTableViewController alloc]init];
            controller = chatVC;
        }
            break;
        case 2:{
              VerifyCodeController *verifyVC = [[VerifyCodeController alloc]initWithPhoneNum:@"18125255678"];
              controller = verifyVC;
        }
            break;
            case 1:{
                LoginController *loginVC = [[LoginController alloc]init];
                controller = loginVC;
            }
            break;
            
        default:
            break;
    }
    return controller;
}
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}
- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    if(DEBUGMODE){
        
    }else{
        NSString * key = [identifierComponents lastObject];
        if([key isEqualToString:DrawerControllerRestorationKey]){
            return self.window.rootViewController;
        } else if ([key isEqualToString:LeftNavigationControllerRestorationKey]) {
            return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
        }   else if ([key isEqualToString:LeftSideDrawerControllerRestorationKey]){
            UIViewController * leftVC = ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
            if([leftVC isKindOfClass:[UINavigationController class]]){
                return [(UINavigationController*)leftVC topViewController];
            }
            else {
                return leftVC;
            }
            
        } else if ([key isEqualToString: CenterControllerRestorationKey]){
            UIViewController * centerVC = ((MMDrawerController *)self.window.rootViewController).centerViewController;
            if([centerVC isKindOfClass:[UINavigationController class]]){
                return [(UINavigationController*)centerVC topViewController];
            }
            else {
                return centerVC;
            }
        }
    }

    return nil;
}
#pragma getter && setter
-(void)setCenterController:(TabBarViewController *)centerController {
    objc_setAssociatedObject(self, &CenterControllerKey, centerController,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setDrawerController:(MMDrawerController *)drawerController {
        objc_setAssociatedObject(self, &DrawerControllerKey, drawerController,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setLeftDrawerController:(LeftDrawerController *)leftDrawerController {
        objc_setAssociatedObject(self, &LeftDrawerControllerKey, leftDrawerController,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(TabBarViewController *)centerController{
    return objc_getAssociatedObject(self, &CenterControllerKey);
}
-(MMDrawerController *)drawerController {
    return objc_getAssociatedObject(self, &DrawerControllerKey);
}
-(LeftDrawerController *)leftDrawerController {
    return objc_getAssociatedObject(self, &LeftDrawerControllerKey);
}
@end
