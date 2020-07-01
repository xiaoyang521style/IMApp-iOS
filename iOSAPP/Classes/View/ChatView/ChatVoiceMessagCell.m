//
//  ChatVoiceMessagCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/17.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatVoiceMessagCell.h"
#import "ChatVoicePlayer.h"
#import "VoiceMessage.h"
#import "DownloadAudioService.h"
#import "VoiceHelper.h"
@interface ChatVoiceMessagCell ()
@property(nonatomic,strong)UIImageView *voicePlayingImageView;
@property(nonatomic,strong)UILabel *voiceDurationLabel;
@end

@implementation ChatVoiceMessagCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(80, 40));
        }];
        
        [self.bubbleImageView addSubview:self.voicePlayingImageView];
        [self.voicePlayingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            SMAS(make.left.equalTo(self.bubbleImageView.mas_left).offset(10));
            make.centerY.equalTo(self.bubbleImageView.mas_centerY).offset(0);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        [self.bubbleImageView addSubview:self.voiceDurationLabel];
        [self.voiceDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            SMAS(make.right.equalTo(self.bubbleImageView.mas_right).offset(5));
            make.centerY.equalTo(self.bubbleImageView.mas_centerY).offset(0);
        }];
        
        self.bubbleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playRecord)];
        [self.bubbleImageView addGestureRecognizer:playTap];
    }
    return self;
}
-(void)playRecord{
    
    void (^didFinishPlay)(void) = ^(){
        [self.voicePlayingImageView stopAnimating];
        self.isPlaying = NO;
        [[ChatVoicePlayer sharePlayer] endPlay];
        ((VoiceMessage *)(self.message.content)).isPlayed = YES;
    };
    
    if (!self.isPlaying) {
        [self.voicePlayingImageView startAnimating];
        self.isPlaying = YES;
        if (((VoiceMessage *)(self.message.content)).wavAudioData) {
            [[ChatVoicePlayer sharePlayer] playVoiceWithData:((VoiceMessage *)(self.message.content)).wavAudioData didFinish:didFinishPlay];
        }else{
//            if (self.message.messageDirection == MessageDirection_SEND) {
//                [[ChatVoicePlayer sharePlayer] playVoiceWithData:((VoiceMessage *)(self.message.content)).wavAudioData didFinish:didFinishPlay];
////                NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////                NSString *dataFilePath = [docsdir stringByAppendingPathComponent:((VoiceMessage *)(self.message.content)).uri];
////                NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
////                [[ChatVoicePlayer sharePlayer] playVoiceWithData:data didFinish:didFinishPlay];
////                ((VoiceMessage *)(self.message.content)).wavAudioData = data;
//            }else{
//
//            }
        }
    }else{
        didFinishPlay();
    }
}
-(void)updateDirection:(MessageDirection)direction{
    [super updateDirection:direction];

    [self.voicePlayingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == MessageDirection_RECEIVE) {
            SMAS(make.left.equalTo(self.bubbleImageView.mas_left).offset(10));
        }else{
            SMAS(make.right.equalTo(self.bubbleImageView.mas_right).offset(-10));
        }
    }];
    
    [self.voiceDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == MessageDirection_RECEIVE) {
            SMAS(make.right.equalTo(self.bubbleImageView.mas_right).offset(-10));
        }else{
            SMAS(make.left.equalTo(self.bubbleImageView.mas_left).offset(10));
        }
    }];
    
    self.voiceDurationLabel.textColor = direction == MessageDirection_RECEIVE ? UIColorFromRGB(0xa2a2a2) : UIColorFromRGB(0x4182b5);
}

-(void)updateMessage:(Message *)message showDate:(BOOL)showDate{
    [super updateMessage:message showDate:showDate];

    VoiceMessage *voiceMessage = (VoiceMessage *)message.content;
    
    self.voicePlayingImageView.animationImages = message.messageDirection == MessageDirection_RECEIVE ? @[[UIImage imageNamed:@"from_voice_1"],[UIImage imageNamed:@"from_voice_2"],[UIImage imageNamed:@"from_voice_3"]] : @[[UIImage imageNamed:@"to_voice_1"],[UIImage imageNamed:@"to_voice_2"],[UIImage imageNamed:@"to_voice_3"]];
    
    self.voicePlayingImageView.image = message.messageDirection == MessageDirection_RECEIVE ? [UIImage imageNamed:@"from_voice"] : [UIImage imageNamed:@"to_voice"];
    
    self.voiceDurationLabel.text = [NSString stringWithFormat:@"%ld''",((VoiceMessage *)message.content).duration];
    float Lmin = 40.f;
    float Lmax = 200.f;
    float barLen = 0.f;
    float barCanChangeLen = Lmax - Lmin;
    float VoicePlayTimes = ((VoiceMessage *)message.content).duration;
    if (VoicePlayTimes > 11.f) {
        barLen = Lmin + VoicePlayTimes * 0.05f * barCanChangeLen; // VoicePlayTimes 为10秒时，正好为可变长度的一半
    } else {
        barLen = Lmin + 0.5 * barCanChangeLen + (VoicePlayTimes - 10.f) * 0.05f * barCanChangeLen;
    }
    
    [self.bubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(barLen, 40));
    }];
    
    if (!voiceMessage.wavAudioData) {
        if (message.messageDirection == MessageDirection_SEND) {
             NSString *docomentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *path = [docomentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld-%lld.wav",message.senderUserId,message.sentTime]];
            NSFileManager *fm = [NSFileManager defaultManager];
            /// 判断文件是否已经存在
            if (![fm fileExistsAtPath:path]) {
                NSString *amrRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *amrpath = [amrRoot stringByAppendingPathComponent:voiceMessage.uri];
                [VoiceHelper amrToWav:amrpath wavSavePath:path];
            }
            voiceMessage.wavAudioData = [NSData dataWithContentsOfFile:path];
        }else{
            NSString *docomentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            
            
            NSString *path = [docomentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld-%lld.wav",message.senderUserId,message.sentTime]];
            [DownloadAudioService downloadAudioWithUrl:voiceMessage.uri saveDirectoryPath:path fileName:@"" finish:^(NSString *filePath) {
                voiceMessage.wavAudioData = [NSData dataWithContentsOfFile:filePath];
                if (self.isPlaying) {
                    void (^didFinishPlay)(void) = ^(){
                        [self.voicePlayingImageView stopAnimating];
                        self.isPlaying = NO;
                        [[ChatVoicePlayer sharePlayer] endPlay];
                    };
                    [self.voicePlayingImageView startAnimating];
                    self.isPlaying = YES;
                    if (((VoiceMessage *)(self.message.content)).wavAudioData) {
                        [[ChatVoicePlayer sharePlayer] playVoiceWithData:((VoiceMessage *)(self.message.content)).wavAudioData didFinish:didFinishPlay];
                    }
                }
            } failed:^{
                NSLog(@"下载音频失败");
            }];
        }
    }
}

-(UIImageView *)voicePlayingImageView{
    if (!_voicePlayingImageView) {
        _voicePlayingImageView = [[UIImageView alloc] init];
        _voicePlayingImageView.userInteractionEnabled = YES;
        _voicePlayingImageView.animationDuration = 1;
        _voicePlayingImageView.animationRepeatCount = 0;
    }
    return _voicePlayingImageView;
}
-(UILabel *)voiceDurationLabel{
    if (!_voiceDurationLabel) {
        _voiceDurationLabel = [[UILabel alloc] init];
        _voiceDurationLabel.textColor = UIColorFromRGB(0x4182b5);
        _voiceDurationLabel.font = [UIFont systemFontOfSize:15];
    }
    return _voiceDurationLabel;
}
@end
