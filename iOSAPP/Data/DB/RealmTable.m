//
// Created by xiaoming on 2017/1/18.
// Copyright (c) 2017 com.yiqihi. All rights reserved.
//

#import "RealmTable.h"
#import "RLMRealmConfiguration.h"
#import "RLMResults.h"
#import "NSDate+Utils.h"
#import <RLMMigration.h>

static RealmTable *realmTable_instance;
static dispatch_once_t realmTable_once;

@implementation RealmTable

+ (RealmTable *)get {
    dispatch_once(&realmTable_once, ^{
        realmTable_instance = [[RealmTable alloc] init];
    });
    return realmTable_instance;
}

- (id)init {
    if (self = [super init]) {
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        config.schemaVersion = 4;
        config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
    
            [migration enumerateObjects:StringPair.className
                                      block:^(RLMObject *oldObject, RLMObject *newObject) {
                                          // 设置新增属性的值
                                          newObject = oldObject;
                                      }];
            
            [migration enumerateObjects:IntegerPair.className
                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
                                      // 设置新增属性的值
                                      newObject = oldObject;
                                  }];
            
            [migration enumerateObjects:Contacts.className
                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
                                      // 设置新增属性的值
                                      newObject = oldObject;
                                  }];
            [migration enumerateObjects:FormRecord.className block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                                    // 设置新增属性的值
                                      newObject = oldObject;
            }];
            
            [migration enumerateObjects:ChatRecord.className block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                // 设置新增属性的值
                newObject = oldObject;
            }];
            NSLog(@"迁移");
        };
        [RLMRealmConfiguration setDefaultConfiguration:config];
        self.instance = [RLMRealm  defaultRealm];
    }
    return self;
}

-(void)dealloc{

}


- (void)writeString:(NSString *)name value:(NSString *)value {
    StringPair *result = [StringPair create:name value:value];
    [_instance beginWriteTransaction];
    [_instance addOrUpdateObject:result];
    [_instance commitWriteTransaction];
}

- (void)writeInt:(NSString *)name value:(NSInteger)value {
    IntegerPair *result = [IntegerPair create:name value:value];
    [_instance beginWriteTransaction];
    [_instance addOrUpdateObject:result];
    [_instance commitWriteTransaction];
}


- (NSString *)readString:(NSString *)name {
    StringPair *result = [StringPair objectForPrimaryKey:name];
    if (result == nil) return nil;
    return result.value;
}

- (NSInteger)readInt:(NSString *)name {
    IntegerPair *result = [IntegerPair objectForPrimaryKey:name];
    if (result == nil) return 0;
    return result.value;
}

- (void)removeString:(NSString *)name {
    StringPair *result = [StringPair objectForPrimaryKey:name];
    if (result == nil) return;
    [_instance beginWriteTransaction];
    [_instance deleteObject:result];
    [_instance commitWriteTransaction];
}

- (void)removeInt:(NSString *)name {
    IntegerPair *result = [IntegerPair objectForPrimaryKey:name];
    if (result == nil) return;
    [_instance beginWriteTransaction];
    [_instance deleteObject:result];
    [_instance commitWriteTransaction];
}



-(void) removeContact:(Contacts *)contact{
    [_instance beginWriteTransaction];
    [_instance deleteObject:contact];
    [_instance commitWriteTransaction];
}
-(void) removeAllContact{
    RLMResults *contacts = [Contacts allObjects];
    for(int i=0;i<contacts.count;i++){
        Contacts *contact= contacts[i];
        [self removeContact:contact];
    }
}

-(void) writeContact:(Contacts*) contact{
    [_instance beginWriteTransaction];
    [_instance addOrUpdateObject:contact];
    [_instance commitWriteTransaction];
}

-(NSMutableArray*) readContacts{
    NSMutableArray * results = [[NSMutableArray alloc ] init];
    RLMResults *contacts = [Contacts allObjects];
    for(int i=0;i<contacts.count;i++){
        Contacts *contact = contacts[i];
        [results addObject:contact];
    }
    return results;
}

-(void)writeChatRecord:(ChatRecord*)chatRecord {
    [_instance beginWriteTransaction];
    [_instance addOrUpdateObject:chatRecord];
    [_instance commitWriteTransaction];
}

-(void)removeChatRecord:(ChatRecord*)chatRecord {
    [_instance beginWriteTransaction];
    [_instance deleteObject:chatRecord];
    [_instance commitWriteTransaction];
}

-(void)removeAllChatRecord {
    RLMResults *chatRecords = [ChatRecord allObjects];
    for(int i=0;i<chatRecords.count;i++){
        ChatRecord *chatRecord = chatRecords[i];
        [_instance beginWriteTransaction];
        [_instance deleteObject:chatRecord];
        [_instance commitWriteTransaction];
    }
}

-(NSMutableArray *)readChatRecord:(NSInteger)userId {
    NSMutableArray *results = [[NSMutableArray alloc ] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"fromUserId = %d OR toUserId = %d",
                         userId, userId];
    RLMResults *chatRecords = [ChatRecord objectsWithPredicate:pred];
    
    for (ChatRecord * chatRecord in chatRecords) {
        [results addObject:chatRecord];
    }
    return results;
}

-(NSMutableArray *)readAllChatRecords {
    NSMutableArray *results = [[NSMutableArray alloc]init];
    RLMResults *chatRecords = [ChatRecord allObjects];
    for (ChatRecord * chatRecord in chatRecords) {
        [results addObject:chatRecord];
    }
    return results;
}
-(void)removeChatRecords:(NSMutableArray *)chatRecords {
    for (ChatRecord * chatRecord in chatRecords) {
        [self removeChatRecord:chatRecord];
    }
}
-(void)updateRead:(NSInteger)userId {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"fromUserId = %d",
                         userId];
     RLMResults *chatRecords = [ChatRecord objectsWithPredicate:pred];
     for (ChatRecord * chatRecord in chatRecords) {
         if (chatRecord.chatRecordType != ChatRecordTypeAudio) {
             ChatRecord * newChatRecord = [[ChatRecord alloc]init];
             newChatRecord.fromUserId = chatRecord.fromUserId;
             newChatRecord.toUserId = chatRecord.toUserId;
             newChatRecord.timestamp = chatRecord.timestamp;
             newChatRecord.content = chatRecord.content;
             newChatRecord.chatRecordType = chatRecord.chatRecordType;
             newChatRecord.sentTime = chatRecord.sentTime;
             chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
             newChatRecord.state = 1;
             [self writeChatRecord:newChatRecord];
         }
     }
}
-(void)removeAllDB {
    [_instance beginWriteTransaction];
    [_instance deleteAllObjects];
    [_instance commitWriteTransaction];
}

-(void)removeChatDB {
    [self removeAllContact];
    [self removeAllChatRecord];
}

-(NSMutableArray *)readSessions {
    
    NSMutableArray *sessions = [NSMutableArray new];
    //先按照联系人
    NSMutableArray *contacts = [self readContacts];
    //根据联系人读会话
    NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    __weak typeof(self) weakself = self;
    
    [contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Contacts *contact = obj;
        NSArray *chatRecords = [weakself readChatRecord:contact.userId];
        //会话时间比较，取出最新的
        if (chatRecords.count > 0) {
            NSArray *chatRecordsDes = [chatRecords sortedArrayUsingDescriptors:@[des]];
            int unReadCount = 0;
            for (ChatRecord * chatRecord in chatRecords) {
                if (chatRecord.fromUserId == contact.userId && chatRecord.state == 0) {
                    unReadCount++;
                }
            }
            NSDictionary *dict = @{@"unReadCount":@(unReadCount),@"chatRecord":[chatRecordsDes firstObject]};
            [sessions addObject:dict];
        }
      
    }];
    
    //会话列表从早到晚排序
    
 
    return sessions;
    
}


@end

@implementation FormRecord

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
+ (instancetype)create:(NSString *)name value:(NSString *)value{
    FormRecord *result = [[FormRecord alloc] init];
    result.name = [name copy];
    result.value = [value copy];
    return result;
}
+ (NSString *)primaryKey
{
    return @"name";
}

@end

@implementation StringPair

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"name";
}

+ (instancetype)create:(NSString *)name value:(NSString *)value {
    StringPair *result = [[StringPair alloc] init];
    result.name = [name copy];
    result.value = [value copy];
    return result;
}

@end


@implementation IntegerPair

- (id)init {
    if (self = [super init]) {
        self.value=0;
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"name";
}

+ (instancetype)create:(NSString *)name value:(NSInteger)value {
    IntegerPair *result = [[IntegerPair alloc] init];
    result.name = [name copy];
    result.value = value;
    return result;
}
@end

@implementation Contacts

- (id)init {
    if (self = [super init]) {
        self.timestamp=[NSDate currentTimestamp];
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"userId";
}

+ (instancetype)create:(int)userId icon:(NSString *)icon username:(NSString *)username roomId:(NSString *)roomId {
    Contacts *result = [[Contacts alloc] init];
    result.userId = userId;
    result.icon = [icon copy];
    result.username = [username copy];
    result.roomId = [roomId copy];
    return result;
}

@end

@implementation ChatRecord

-(id)init {
    if ([super init]) {
          self.timestamp = [NSDate currentTimestamp];
    }
    return self;
}

+(instancetype)createFromUserId:(int)fromUserId toUserId:(int)toUserId  chatRecordType:(int)chatRecordType content:(NSString *)content state:(int)state sendTime:(long long)sendTime{
    ChatRecord *chatRecord = [[ChatRecord alloc]init];
    chatRecord.fromUserId = fromUserId;
    chatRecord.toUserId = toUserId;
    chatRecord.chatRecordType = chatRecordType;
    chatRecord.sentTime = sendTime;
    chatRecord.content = [content copy];
    chatRecord.state = state;
    return chatRecord;
}

+(NSString *)primaryKey {
    return @"primaryKey";
}

@end
