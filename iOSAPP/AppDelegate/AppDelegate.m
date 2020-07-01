//
//  AppDelegate.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+RootController.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+AppLifeCircle.h"
#import "SecurityUtil.h"
#import  <UserNotifications/UserNotifications.h>
#import "APNSPush.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setRootController]; //设置根视图
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self config];
    [self initUserLogin];   //初始化用户
    [self listenNetWorkingStatus];  //监听网络是否可用
    [self addFPSFPSLabel];
    NSString*directory=NSHomeDirectory();
    NSLog(@"directory:%@",directory);
    //推送的形式：标记，声音，提示
    if (IOS_VERSION >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
            [center setDelegate:self];
            UNAuthorizationOptions type = UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert;
            [center requestAuthorizationWithOptions:type completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"注册成功");
                }else{
                    NSLog(@"注册失败");
                }
            }];
        } else {
            // Fallback on earlier versions
        }if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        } else {
            // Fallback on earlier versions
        }
    }else if (IOS_VERSION >= 8.0){
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{//ios8一下
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    // 注册获得device Token
    
    [application registerForRemoteNotifications];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}


- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[SocketClient get] stopLiveTimer];
    [SocketClient get].isBackgound = true;
    [[SocketClient get]bye];
    [[SocketClient get] disConnect];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([Context get].userId != 0) {
        if (![SocketClient get].isActive) {
            [[SocketClient get] reconnect];
        }
        [[SocketClient get] startLiveTimer];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //iOS7以后收到推送 推送结果会在这里响应
    //iOS10 以后不再响应这里
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    //注册成功，将deviceToken保存到应用服务器[数据库]中
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    [APNSPush registerAPNS:deviceTokenStr];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}
- (void)application:(UIApplication *)applicationdid FailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registfail%@",error);
}

//在前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
    completionHandler(UNNotificationPresentationOptionBadge|
                      
                      UNNotificationPresentationOptionSound|
                      
                      UNNotificationPresentationOptionAlert);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    //处理推送过来的数据
    NSLog(@"%@",response.notification.request.content.userInfo);
    completionHandler();
}

@end
