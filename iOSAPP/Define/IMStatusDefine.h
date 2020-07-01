//
//  IMStatusDefine.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef IMStatusDefine_h
#define IMStatusDefine_h

typedef NS_ENUM(NSInteger, ChatRecordType) {
    /*!
     文本
     */
    ChatRecordTypeText = 1,
    /*!
     图片
     */
    ChatRecordTypeImage,
    /*!
     声音
     */
    ChatRecordTypeAudio,
    /*!
     位置
     */
    ChatRecordTypeLocation,
    /*!
     视频
     */
    ChatRecordTypeVideo
};


/*!
 消息的方向
 */
typedef NS_ENUM(NSUInteger, MessageDirection) {
    /*!
     发送
     */
    MessageDirection_SEND = 1,
    
    /*!
     接收
     */
    MessageDirection_RECEIVE = 2
};

#pragma mark RCSentStatus - 消息的发送状态
/*!
 消息的发送状态
 */
typedef NS_ENUM(NSInteger, SentStatus) {
    /*!
     发送中
     */
    SentStatus_SENDING = 10,
    
    /*!
     发送失败
     */
    SentStatus_FAILED = 20,
    
    /*!
     已发送成功
     */
    SentStatus_SENT = 30,
    
    /*!
     对方已接收
     */
    SentStatus_RECEIVED = 40,
    
    /*!
     对方已阅读
     */
    SentStatus_READ = 50,
    
    /*!
     对方已销毁
     */
    SentStatus_DESTROYED = 60
};


#pragma mark RCReceivedStatus - 消息的接收状态
/*!
 消息的接收状态
 */
typedef NS_ENUM(NSUInteger, ReceivedStatus) {
    /*!
     未读
     */
    ReceivedStatus_UNREAD = 0,
    
    /*!
     已读
     */
    ReceivedStatus_READ = 1,
    
    /*!
     已听
     
     @discussion 仅用于语音消息
     */
    ReceivedStatus_LISTENED = 2,
    
    /*!
     已下载
     */
    ReceivedStatus_DOWNLOADED = 4,
    
    /*!
     该消息已经被其他登录的多端收取过。（即改消息已经被其他端收取过后。当前端才登录，并重新拉取了这条消息。客户可以通过这个状态更新
     UI，比如不再提示）。
     */
    ReceivedStatus_RETRIEVED = 8,
    
    /*!
     该消息是被多端同时收取的。（即其他端正同时登录，一条消息被同时发往多端。客户可以通过这个状态值更新自己的某些
     UI状态）。
     */
    ReceivedStatus_MULTIPLERECEIVE = 16,
    
};

#endif /* IMStatusDefine_h */
