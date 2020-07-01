//
//  ChatRecordVoice.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatRecordVoice.h"
#import "ChatRecordVoiceHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceHelper.h"
@interface ChatRecordVoice () <AVAudioRecorderDelegate>
@property(nonatomic,strong)AVAudioSession *audioSession;
@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)NSTimer *timer;
@end
@implementation ChatRecordVoice
-(instancetype)initWithDelegate:(id<RecorderVoiceDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}
-(void)startRecord{
    [self configSession];
    [self configRecord];
    [self.audioRecorder record];
    
    [ChatRecordVoiceHUD showRecording];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(observerVoiceVolume) userInfo:nil repeats:YES];
}
-(void)completeRecord{
    if (self.audioRecorder.currentTime > 2) {
        [ChatRecordVoiceHUD dismiss];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:self.recordFilePath];
        if ([self.delegate respondsToSelector:@selector(recorderVoiceSuccessWithVoiceData: path: duration:)]) {
            [self.delegate recorderVoiceSuccessWithVoiceData:data path:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.wav"] duration:self.audioRecorder.currentTime];
        }
    }else {
        [ChatRecordVoiceHUD dismissWithRecordShort];
    }
    [self endRecord];
}
-(void)cancelRecord{
    [self endRecord];
    [ChatRecordVoiceHUD dismiss];
}
- (void)endRecord{
    [self.audioRecorder deleteRecording];
    [self.audioRecorder stop];
    [self.timer invalidate];
}
- (void)observerVoiceVolume{
    [self.audioRecorder updateMeters];
    CGFloat lowPassResults = pow(10, (0.05 * [self.audioRecorder peakPowerForChannel:0]));
    [ChatRecordVoiceHUD updatePeakPower:lowPassResults];
}

-(void)configSession{
    self.audioSession = [AVAudioSession sharedInstance];
    
    NSError *error;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (self.audioSession) {
        [self.audioSession setActive:YES error:nil];
    }
}
-(void)configRecord{
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                              [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                              [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                              //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                              //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                              //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                              nil];
    
    NSURL *tmpUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.wav"]];
    
    NSError *error;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:tmpUrl
                                                     settings:settings
                                                        error:&error];
    if (error) NSLog(@"%@",error);
    
    
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    [self.audioRecorder prepareToRecord];
}


-(NSURL *)recordFilePath{
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.wav"]];
}
@end
