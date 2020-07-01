//
//  Navigator.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

#import "FindContactsController.h"
#import "User.h"
@interface Navigator : UINavigationController
+(Navigator *)get;
-(void)showChatControllerWithUser:(User *)user roomId:(NSString *)roomId;
-(void)showFindContacts;
-(void)pushVC:(UIViewController *)controller;
-(void)presentVC:(UIViewController *)controller;
-(void)presentLoginVC;
-(void)showScanVC;
@end
