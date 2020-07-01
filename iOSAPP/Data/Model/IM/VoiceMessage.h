//
//  VoiceMessage.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MessageContent.h"

@interface VoiceMessage : MessageContent <NSCoding>

@property(nonatomic, assign) BOOL isPlayed;

/*!
 wav格式的音频数据
 */
@property(nonatomic, strong) NSData *wavAudioData;

/*!
 语音消息的时长
 */
@property(nonatomic, assign) long duration;

/*!
 语音消息地址
 */
@property(nonatomic, copy) NSString *uri;

+ (instancetype)messageWithAudio:(NSData *)audioData duration:(long)duration;

+ (instancetype)messageWithAudioURi:(NSString *)uri duration:(long)duration;
@end
