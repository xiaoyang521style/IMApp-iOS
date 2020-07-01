//
//  Message.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "Message.h"

@implementation Message
- (instancetype)initWithTargetId:(long)targetId
                       direction:(MessageDirection)messageDirection
                       messageId:(long)messageId
                         content:(MessageContent *)content {
    if ([super init]) {
        _targetId = targetId;
        _content = content;
        _messageDirection = messageDirection;
        _messageId = messageId;
    }
    return self;
}
@end
