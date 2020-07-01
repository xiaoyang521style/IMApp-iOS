//
//  ChatEmojiView.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger emojiBoardHeight = 223;

@class ChatEmojiView;

@protocol ChatEmojiViewDelegate <NSObject>
@required
- (void)emojiView:(ChatEmojiView *)emojiView didPressFaceValue:(NSString*)face;
- (void)emojiViewDidPressSendButton:(ChatEmojiView *)emojiView ;
- (void)emojiViewDidPressDeleteButton:(ChatEmojiView *)emojiView ;
@end

@interface ChatEmojiView : UIView

@property(nonatomic, retain) NSArray *items;

@property (nonatomic, weak) id<ChatEmojiViewDelegate> delegate;
+ (BOOL)isEmojisWithHeightChar:(const unichar)hs
                    andLowChar:(const unichar)ls;
@end
