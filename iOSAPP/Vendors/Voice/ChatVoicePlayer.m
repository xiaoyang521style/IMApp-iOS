//
//  VoicePlayer.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ChatVoicePlayer () <AVAudioPlayerDelegate>
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic,copy)void (^didFinishBlock)(void);
@end
@implementation ChatVoicePlayer
+(ChatVoicePlayer *)sharePlayer{
    static dispatch_once_t onceToken;
    static ChatVoicePlayer *player;
    dispatch_once(&onceToken, ^{
        player = [[ChatVoicePlayer alloc] init];
    });
    return player;
}
-(instancetype)init{
    if (self = [super init]) {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    }
    return self;
}
-(void)playVoiceWithData:(NSData *)data didFinish:(void (^)(void))didFinish{
    if (self.player) {
        [self.player stop];
        self.player.delegate = nil;
        self.player = nil;
    }
    self.didFinishBlock = didFinish;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    self.player.volume = 1.0f;
    if (error) {
        NSLog(@"%@", error);
        if (self.didFinishBlock) self.didFinishBlock();
    }
    self.player.delegate = self;
    [self.player play];
}
-(void)playVoiceWithUri:(NSURL *)uri didFinish:(void (^)(void))didFinish{
    if (self.player) {
        [self.player stop];
        self.player.delegate = nil;
        self.player = nil;
    }
    self.didFinishBlock = didFinish;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:uri error:&error];
    self.player.volume = 1.0f;
    if (error) NSLog(@"%@", error);
    self.player.delegate = self;
    [self.player play];
    
}
-(void)endPlay{
    if (self.player && self.player.isPlaying) {
        [self.player stop];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.didFinishBlock) self.didFinishBlock();
}
@end
