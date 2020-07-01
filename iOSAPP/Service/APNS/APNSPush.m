//
//  APNSPush.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#define DeviceToken_URI @"pushRegist"

#define DeviceTokenUser_URI @"updatePushToken"

#import "APNSPush.h"
#import <AFNetworking.h>
#import "DeviceTool.h"
static APNSPush *apnsPush_instance;
static dispatch_once_t apnsPush_once;

@implementation APNSPush
+ (APNSPush *)get {
    dispatch_once(&apnsPush_once, ^{
        apnsPush_instance = [[APNSPush alloc]init];
    });
    return apnsPush_instance;
}
+(void)registerAPNS:(NSString *)deviceToken {
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:DEVIVETOKEN];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:deviceToken forKey:@"deviceToken"];
    [params setObject:@1 forKey:@"deviceModel"];
    [params setObject:[DeviceTool get].systemVersion forKey:@"systemVersion"];
    [params setObject:[DeviceTool get].deviceName forKey:@"deviceName"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *uri;
    if (DEBUGMODE) {
        uri = [NSString stringWithFormat:@"%@/%@",DebugRestServer,DeviceToken_URI];
    }else{
        uri = [NSString stringWithFormat:@"%@/%@",RestServer,DeviceToken_URI];
    }
    [manager POST:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"DeviceToken写入成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"DeviceToken写入失败");
    }];
}

+(void)updatePushToken {
    
    // 如果是模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        
       
        
    }else{
        
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:DEVIVETOKEN];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:deviceToken forKey:@"deviceToken"];
        [params setObject:@([Context get].userId)forKey:@"userId"];
        [params setObject:@1 forKey:@"deviceModel"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *uri;
        if (DEBUGMODE) {
            uri = [NSString stringWithFormat:@"%@/%@",DebugRestServer,DeviceTokenUser_URI];
        }else{
            uri = [NSString stringWithFormat:@"%@/%@",RestServer,DeviceTokenUser_URI];
        }
        [manager POST:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"DeviceToken和用户绑定成功");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"DeviceToken和用户绑定失败");
        }];
        
    }

}
@end
