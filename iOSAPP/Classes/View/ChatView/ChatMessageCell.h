//
//  ChatMessageCell.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/17.
//  Copyright © 2018年 赵阳. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NSDate+Utils.h"
#import "Message.h"
#define SMAS(x) [self.constraints addObject:x]


@class ChatImageMessageCell;
@class ChatVideoMessageCell;
@protocol ChatMessageCellDelegate<NSObject>
-(void)chatImageMessageCellDidClickImage:(ChatImageMessageCell *)cell;
-(void)chatVideoMessageCellPlayVideoClick:(ChatVideoMessageCell *)cell;
@end

@interface MessageBubble : UIImageView

@end

@interface ChatMessageCell : UITableViewCell
@property(nonatomic,strong)MessageBubble *bubbleImageView;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UIView *statusView;
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)UIButton *retryBtn;
@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)NSMutableArray *constraints;
@property(nonatomic,strong)UILabel *dateTimeLabel;
@property (nonatomic, strong) Message *message;
@property (nonatomic, copy)void(^reSendAction)(Message *message);
@property (nonatomic,strong)void(^clickAvatar)(MessageDirection msgDirection);
@property (nonatomic, weak)id<ChatMessageCellDelegate> delegate;
-(void)updateDirection:(MessageDirection)direction;
-(void)updateMessage:(Message*)message showDate:(BOOL)showDate;
-(void)setMsgStatus:(SentStatus)msgStatus;
@end
