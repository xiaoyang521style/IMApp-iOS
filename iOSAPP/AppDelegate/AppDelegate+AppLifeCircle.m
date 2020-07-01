//
//  AppDelegate+AppLifeCircle.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "AppDelegate+AppLifeCircle.h"
#import "AppDelegate+AppService.h"
#import "YYFPSLabel.h"
@implementation AppDelegate (AppLifeCircle)
//初始化用户
-(void)initUserLogin{
  //  [Context get].token = @"86440fa2384e50d5fadf6122de3d372d";
//    if([[Context get].token isEqualToString:@""])
//    return;
    [self connectServer];
   
//    [HttpClient loginCheckoutBlock:^(HttpResponse *response) {
//        if(response.isSucess) {
//            [[Context get].loginSubject sendNext:@YES];
//            [Context get].isLogin = YES;
//            
//        }else{
//            [[Context get].loginSubject sendNext:@NO];
//            [[Context get]logout];
//        }
//    }];
}

//监听网络是否可用
-(void)listenNetWorkingStatus{
    //1:创建网络监听者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    //2:获取网络状态
    /*
     AFNetworkReachabilityStatusUnknown          = 未知网络，
     AFNetworkReachabilityStatusNotReachable     = 没有联网
     AFNetworkReachabilityStatusReachableViaWWAN = 蜂窝数据
     AFNetworkReachabilityStatusReachableViaWiFi = 无线网
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有联网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"无线网");
                break;
            default:
                break;
        }
    }];
    
    //开启网络监听
    [manager startMonitoring];
}
-(void)addFPSFPSLabel {
    if (DEBUGMODE) {
        YYFPSLabel *fpsLabel = [YYFPSLabel new];
        fpsLabel.frame = CGRectMake(200, 200, 50, 30);
        [fpsLabel sizeToFit];
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:fpsLabel];
    }
}
@end
