//
//  AppDelegate+AppLifeCircle.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppLifeCircle)
//初始化用户
-(void)initUserLogin;
//监听网络是否可用
-(void)listenNetWorkingStatus;
-(void)addFPSFPSLabel;
@end
