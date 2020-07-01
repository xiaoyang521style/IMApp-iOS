//
//  APNSPush.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNSPush : NSObject
+(void)registerAPNS:(NSString *)deviceToken;
+(void)updatePushToken;
@end
