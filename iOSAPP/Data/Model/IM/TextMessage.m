//
//  TextMessage.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "TextMessage.h"

@implementation TextMessage
/*!
 初始化文本消息
 
 @param content 文本消息的内容
 @return        文本消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content {
    TextMessage *textMessage = [[TextMessage alloc]init];
    textMessage.content = content;
    return textMessage;
}
@end
