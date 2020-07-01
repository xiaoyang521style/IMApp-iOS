//
//  ChatRecordVoice.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecorderVoiceDelegate <NSObject>
-(void)recorderVoiceFailure;
-(void)recorderVoiceSuccessWithVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration;
@end

@interface ChatRecordVoice : NSObject
@property(nonatomic,assign)id <RecorderVoiceDelegate> delegate;
-(instancetype)initWithDelegate:(id <RecorderVoiceDelegate>)delegate;
-(void)startRecord;
-(void)completeRecord;
-(void)cancelRecord;
@end
