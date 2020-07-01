//
//  User.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"name" : @"name",
             @"avatar" : @"avatar",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_users";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}
@end
