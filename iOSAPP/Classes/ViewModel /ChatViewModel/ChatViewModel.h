//
//  ChatViewModel.h
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
typedef void (^Response)(BOOL suceess, Message* message);

@class RACCommand;
@class User;

@interface ChatViewModel : NSObject

@property (nonatomic, copy) NSMutableArray *messages;

@property (nonatomic, strong, readonly) User *user;

- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId;

-(Message *)handelChatRecord:(ChatRecord *)chatRecord;

/**
 发送文案
 */

- (void)sendText:(NSString *)textStr block:(Response)block;

-(void)sendImage:(UIImage *)image asset:(PHAsset *)asset block:(Response)block;

-(void)sendVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration block:(Response)block;
/**发送视频*/
-(void)sendVideo:(NSData *)videoData image:(UIImage*)image asset:(PHAsset *)asset block:(Response)block;

@end
