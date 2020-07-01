//
//  Message.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageContent.h"
#import "ReadReceiptInfo.h"
@interface Message : NSObject

/*!
 目标会话ID
 */
@property(nonatomic, assign) long targetId;

@property(nonatomic, assign) ChatRecordType type;
/*!
 消息的ID
 
 @discussion 本地存储的消息的唯一值（数据库索引唯一值）
 */
@property(nonatomic, assign) long messageId;

/*!
 消息的方向
 */
@property(nonatomic, assign) MessageDirection messageDirection;

/*!
 消息的发送者ID
 */
@property(nonatomic, assign)long senderUserId;

/*!
 消息的接收状态
 */
@property(nonatomic, assign) ReceivedStatus receivedStatus;


/*!
 消息的发送状态
 */
@property(nonatomic, assign) SentStatus sentStatus;

/*!
 消息的接收时间（Unix时间戳、毫秒）
 */
@property(nonatomic, assign) long long receivedTime;

/*!
 消息的发送时间（Unix时间戳、毫秒）
 */
@property(nonatomic, assign) long long sentTime;

/*!
 消息的类型名
 */
@property(nonatomic, strong) NSString *objectName;

/*!
 消息的内容
 */
@property(nonatomic, strong) MessageContent *content;

/*!
 阅读回执状态
 */
@property(nonatomic, strong) ReadReceiptInfo *readReceiptInfo;

/*!
 RCMessage初始化方法
 
 @param  conversationType    会话类型
 @param  targetId            目标会话ID
 @param  messageDirection    消息的方向
 @param  messageId           消息的ID
 @param  content             消息的内容
 */
- (instancetype)initWithTargetId:(long)targetId
                   direction:(MessageDirection)messageDirection
                   messageId:(long)messageId
                     content:(MessageContent *)content;



@end
