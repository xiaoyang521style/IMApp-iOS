//
//  VoiceMessage.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "VoiceMessage.h"

@implementation VoiceMessage
+ (instancetype)messageWithAudio:(NSData *)audioData duration:(long)duration {
    VoiceMessage *voiceMessage = [VoiceMessage new];
    voiceMessage.duration = duration;
    voiceMessage.wavAudioData = audioData;
    return voiceMessage;
}

+ (instancetype)messageWithAudioURi:(NSString *)uri duration:(long)duration{
    VoiceMessage *voiceMessage = [VoiceMessage new];
    voiceMessage.uri = uri;
    voiceMessage.duration = duration;
    return voiceMessage;
}
@end
