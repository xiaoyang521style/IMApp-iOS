//
//  DeviceInfo.m
//  etst
//
//  Created by develop5 on 2018/1/22.
//  Copyright © 2018年 yiqihi. All rights reserved.
//

#import "DeviceInfo.h"
#import "SSKeychain.h"
#import <UIKit/UIKit.h>
@implementation DeviceInfo
+ (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" " account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" " account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}
@end
