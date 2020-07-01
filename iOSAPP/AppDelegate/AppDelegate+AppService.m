//
//  AppDelegate+AppService.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "Consts.h"
#import "SocketClient.h"
#import "InternalClock.h"
@implementation AppDelegate (AppService)

-(void)config{
    [Consts initialize];
    [self readServerNode];
    [InternalClock clock];
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [DeviceTool addShipBackUpAttributeToUrl:docDir];
}
-(void)readServerNode{
    __weak typeof(self) weakself = self;
    [[Context get]readServerNode:false HttpCallBack:^(BOOL xeach, NSString *message) {
        if (xeach) {
            NSLog(@"读取版本数据成功");
        }else{
            NSLog(@"读取版本数据失败");
        }
    }];
}

-(void)connectServer{
    [[SocketClient get] connect:@"login"];
}
@end
