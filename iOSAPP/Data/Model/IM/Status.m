//
//  Status.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "Status.h"

@implementation Status

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userId" : @"user_id",
             @"username" : @"username",
             @"avatar" : @"avatar",
             @"content" : @"content",
             @"imageURL" : @"image_url",
             @"likeNum" : @"like_num",
             @"time" : @"time",
             @"imageScale" : @"image_scale",
             @"youLike" : @"you_like",
             };
}

- (NSString *)time {
    return [NSString stringWithFormat:@"%@ %@",[_time substringToIndex:10], [_time substringWithRange:NSMakeRange(11, 8)]];
}


+ (NSString *)FMDBTableName {
    return @"t_statuses";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}
@end
