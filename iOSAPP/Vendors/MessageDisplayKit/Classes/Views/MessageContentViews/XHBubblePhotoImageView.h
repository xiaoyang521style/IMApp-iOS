//
//  XHBubblePhotoImageView.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-28.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageBubbleFactory.h"

#define kXHBubblePhotoMargin 8.0f // 上下左右的边距

@interface XHBubblePhotoImageView : UIView

/**
 *  发送后，需要显示的图片消息的图片，或者是视频的封面
 */
@property (nonatomic, strong) UIImage *messagePhoto;

@property (nonatomic, strong) UIImageView *imageView;

/**
 *  加载网络图片的时候，需要用到转圈的控件
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

/**
 *
 *
 *  @param messagePhoto
 *  @param bubbleMessageType
 */
/**
 *  根据目标图片配置三角形具体位置
 *
 *  @param messagePhoto      目标图片
 *  @param thumbnailUrl      目标图片缩略图的URL链接
 *  @param originPhotoUrl    目标图片原图的URL链接
 *  @param bubbleMessageType 目标消息类型
 */
- (void)configureMessagePhoto:(UIImage *)messagePhoto thumbnailUrl:(NSString *)thumbnailUrl originPhotoUrl:(NSString *)originPhotoUrl onBubbleMessageType:(XHBubbleMessageType)bubbleMessageType;

/**
 *  获取消息类型比如发送或接收
 *
 *  @return 消息类型
 */
- (XHBubbleMessageType)getBubbleMessageType;

@end
