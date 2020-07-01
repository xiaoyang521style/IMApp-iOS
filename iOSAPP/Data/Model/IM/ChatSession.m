//
//  ChatSession.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatSession.h"

@implementation ChatSession
+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"userId" : @"identity",
             @"userName" : @"username",
             @"sessionName" : @"session_name",
             @"imageURL" : @"image_url",
             @"lastSentence" : @"last_sentence",
             @"time" : @"time",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_chat_sessions";
}
+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}
- (BOOL)isEqualToSession:(ChatSession *)session {
    return self.userId.integerValue == session.userId.integerValue;
}
@end
