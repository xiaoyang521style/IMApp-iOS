//
//  DeviceTool.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/29.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "DeviceTool.h"
#import "DeviceInfoManager.h"
#import "NetWorkInfoManager.h"
#import "BatteryInfoManager.h"


static DeviceTool *deviceTool_instance;
static dispatch_once_t deviceTool_once;

@implementation DeviceTool
+ (DeviceTool *)get {
    dispatch_once(&deviceTool_once, ^{
        deviceTool_instance = [[DeviceTool alloc] init];
    });
    return deviceTool_instance;
}
- (id)init {
    if (self = [super init]) {
        _deviceName = [[DeviceInfoManager sharedManager] getDeviceName];
        _iPhoneName = [UIDevice currentDevice].name;
        _appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _systemName = [UIDevice currentDevice].systemName;
        _systemVersion = [UIDevice currentDevice].systemVersion;
        _batteryLevel = [[UIDevice currentDevice] batteryLevel];
        _deviceIP = [[NetWorkInfoManager sharedManager] getDeviceIPAddresses];
        _macAddress = [[DeviceInfoManager sharedManager] getMacAddress];
        _idfa = [[DeviceInfoManager sharedManager] getIDFA];
        _uuid =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        _cellIP = [[NetWorkInfoManager sharedManager] getIpAddressCell];
        _wifiIP = [[NetWorkInfoManager sharedManager] getIpAddressWIFI];
    }
    return self;
}

-(float)parseVersion{
    
    NSArray *arr = [_appVerion componentsSeparatedByString:@"."];
    NSString *parseVersionString;
    if (arr.count==1) {
        parseVersionString = arr[1];
    }else if(arr.count == 2){
        parseVersionString = [arr componentsJoinedByString:@"."];
    }else{
        NSMutableArray *newArr = [NSMutableArray new];
        for(int i = 1 ;i<arr.count ; i++){
            [newArr addObject:arr[i]];
        }
        parseVersionString = [newArr componentsJoinedByString:@""];
        parseVersionString = [NSString stringWithFormat:@"%@.%@",arr[0],parseVersionString];
    }
    return [parseVersionString floatValue];
}
+ (BOOL)addShipBackUpAttributeToUrl:(NSString *)url {
    NSURL* URL = [NSURL fileURLWithPath:url];
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool:YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


@end
