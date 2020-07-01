//
//  UserManager.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface UserManager : NSObject
+ (instancetype)sharedManager;

- (RACSignal *)loginWithUserId:(NSString *)userId password:(NSString *)password;

- (RACSignal *)fetchContactsWithUserId:(NSString *)userId;

- (User *)getUserById:(NSNumber *)userId;
@end
