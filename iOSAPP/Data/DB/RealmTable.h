//
// Created by xiaoming on 2017/1/18.
// Copyright (c) 2017 com.yiqihi. All rights reserved.
//

#pragma mark RCSentStatus - 消息的类型




#import <Foundation/Foundation.h>

@interface FormRecord : RLMObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *value;
+ (instancetype)create:(NSString *)name value:(NSString *)value;
@end

@interface StringPair : RLMObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *value;
+ (instancetype)create:(NSString *)name value:(NSString *)value;

@end


@interface IntegerPair : RLMObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger value;

+ (instancetype)create:(NSString *)name value:(NSInteger)value;
@end


@interface Contacts : RLMObject
@property(nonatomic, copy) NSString *username;
@property(nonatomic, assign) int userId;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, assign) NSInteger timestamp;
@property(nonatomic, assign) NSInteger type;
+ (instancetype)create:(int)userId icon:(NSString *)icon username:(NSString *)username roomId:(NSString *)roomId;
@end

@interface ChatRecord : RLMObject

@property (nonatomic, copy)NSString *primaryKey;

@property (nonatomic, assign)int fromUserId;
@property (nonatomic, assign)int toUserId;
@property (nonatomic, assign)ChatRecordType chatRecordType;
@property (nonatomic, assign) NSInteger timestamp;

@property (nonatomic, assign)int state;
/*!
 消息的内容
 */
@property (nonatomic, copy) NSString *content;
/*!
 消息的发送时间（Unix时间戳、毫秒）
 */
@property(nonatomic, assign) long long sentTime;
/*!
 消息的发送状态
 */
@property (nonatomic, assign) SentStatus sentStatus;
+(instancetype)createFromUserId:(int)fromUserId toUserId:(int)toUserId  chatRecordType:(int)chatRecordType content:(NSString *)content state:(int)state sendTime:(long long)sendTime;
@end

@interface RealmTable : NSObject

@property(nonatomic, strong) RLMRealm *instance;

+ (RealmTable *)get;

- (void)writeString:(NSString *)name value:(NSString *)value;

- (void)writeInt:(NSString *)name value:(NSInteger)value;

- (NSInteger)readInt:(NSString *)name;

- (NSString *)readString:(NSString *)name;

- (void)removeInt:(NSString *)name;

- (void)removeString:(NSString *)name;


-(NSMutableArray*) readContacts;

-(void)writeContact:(Contacts*) contact;

-(void)removeContact:(Contacts *)contact;

-(void) removeAllContact;

-(void)writeChatRecord:(ChatRecord*)chatRecord;

-(void)removeAllChatRecord;

-(void)removeChatRecord:(ChatRecord*)chatRecord;

-(NSMutableArray *)readChatRecord:(NSInteger)userId;

-(NSMutableArray *)readAllChatRecords;

-(void)removeChatRecords:(NSMutableArray *)chatRecord;

-(void)updateRead:(NSInteger)userId;

-(void)removeAllDB;

-(void)removeChatDB;

-(NSMutableArray *)readSessions;

@end





