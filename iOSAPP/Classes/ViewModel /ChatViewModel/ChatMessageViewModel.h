//
//  ChatMessageViewModel.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"
#import "User.h"
typedef void (^Response)(BOOL suceess, XHMessage* message);

#import "XHMessage.h"

@class RACCommand;
@class User;

@interface ChatMessageViewModel : NSObject

@property (nonatomic, copy) NSMutableArray *messages;

@property (nonatomic, strong, readonly) User *user;

- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId;

- (XHMessage *)handelChatRecord:(ChatRecord *)chatRecord;

/**
 发送文案
 */

- (void)sendText:(NSString *)textStr date:(NSDate *)date block:(Response)block;

/**
 发送图片
 */
-(void)sendThumbImage:(UIImage *)thumbImage  previewImage:(UIImage *)previewImage asset:(PHAsset *)asset date:(NSDate *)date block:(Response)block;

/**
 发送视频
 */
-(void)sendVideo:(NSData *)videoData image:(UIImage*)image date:(NSDate *)date asset:(PHAsset *)asset block:(Response)block;

/**发送音频*/
-(void)sendVoicePath:(NSString *)path date:(NSDate *)date duration:(long)duration block:(Response)block;

@end
