//
//  MessageBus.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketClient.h"

@class ChatRecord;
@class Contacts;

@interface MessageBus : NSObject

@property(nonatomic, strong)NSMutableArray *contacts;

@property(nonatomic, strong)NSMutableArray *chatRecords;

+(instancetype)get;

-(void)handleMessage:(NSDictionary *)dict;

-(void)writeContacts:(NSArray *)contacts ;

-(Contacts *)writeContact:(NSDictionary *)contactDict;

-(NSMutableArray *)readContacts;

-(void)sendChatRecord:(ChatRecord *)chatRecord roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete;

-(NSMutableArray *)readChatRecordHistory:(NSInteger)userId;

@end
