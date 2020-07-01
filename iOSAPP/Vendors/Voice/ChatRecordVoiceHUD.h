//
//  ChatRecordVoiceHUD.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRecordVoiceHUD : UIView
@property(nonatomic,strong)UIButton *statusBtn;
@property(nonatomic,strong)UIImageView *recordTipImage;

+(void)updatePeakPower:(CGFloat)peakPower;
+(void)showRecording;
+(void)showWCancel;
+(void)dismissWithRecordShort;
+(void)dismiss;
@end
