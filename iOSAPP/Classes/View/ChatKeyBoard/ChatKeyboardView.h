//
//  ChatKeyboardView.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMoreView.h"
@protocol ChatKeyboardDelegate <NSObject>

@optional //非必实现的方法

/**
 点击发送时输入框内的文案
 
 @param textStr 文案
 */
- (void)textViewContentText:(NSString *)textStr;
/**
 键盘的frame改变
 */
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY;

- (void)keyboardSelectType:(ChatMoreType) type;
- (void)recorderVoiceWithVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration;
@end

@interface ChatKeyboardView : UIView<UITextViewDelegate>

@property (nonatomic, weak) id <ChatKeyboardDelegate>delegate;
@end
