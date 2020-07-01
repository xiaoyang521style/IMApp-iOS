//
//  DeviceTool.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/29.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DeviceTool : NSObject;
//to 3.8.2 ---->3.82  ;   3.82 ---->3.82
+ (DeviceTool *)get;
/**设备型号*/
@property(nonatomic, copy) NSString *deviceName;

/**iPhone名称*/
@property(nonatomic, copy) NSString *iPhoneName;

/**app版本号*/
@property(nonatomic, copy) NSString *appVerion;

/**电池电量*/
@property(nonatomic, assign) CGFloat batteryLevel;

/**当前系统名称*/
@property(nonatomic, copy) NSString *systemName;

/**当前系统版本号*/
@property(nonatomic, copy) NSString *systemVersion;

@property(nonatomic, copy) NSString *deviceIP;

@property(nonatomic, copy) NSString *macAddress;
/**广告位标识符*/
@property(nonatomic, copy) NSString *idfa;
/**唯一识别码uuid*/
@property(nonatomic, copy) NSString *uuid;

@property(nonatomic, copy) NSString *wifiIP;

@property(nonatomic, copy) NSString *cellIP;

//to 3.8.2 ---->3.82  ;   3.82 ---->3.82

-(float)parseVersion;

+ (BOOL)addShipBackUpAttributeToUrl:(NSString *)url;
@end
