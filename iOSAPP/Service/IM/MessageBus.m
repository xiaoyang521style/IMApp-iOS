//
//  MessageBus.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MessageBus.h"
#import "APNSPush.h"
#define IsReceiptMessage(object) (object.echo)

static MessageBus *messageBus_instance;
static dispatch_once_t messageBus_once;

@implementation MessageBus

+(instancetype)get {
    dispatch_once(&messageBus_once, ^{
        messageBus_instance = [[MessageBus alloc]init];
    });
    return messageBus_instance;
}

-(instancetype)init {
    if ([super init]) {
        [self readContacts];
        [self readAllChatRecords];
    }
    return self;
}

-(void)handleLogin:(NSDictionary *)dict {
    [Context get].userId = [dict[@"result"][@"userId"] intValue];
    [[RealmTable get]writeInt:USERID value:[Context get].userId];
    [[SocketClient get] getContactList];
}

-(void)handleMessage:(NSDictionary *)dict {
    NSString *action = dict[@"action"];
    if ([action isEqualToString:@"login"]) {
        [[MessageBus get] handleLogin:dict];
        [APNSPush updatePushToken];
    }
    if ([action isEqualToString:@"getContactList"]) {
        [[MessageBus get] handleGetContactList:dict];
        [[SocketClient get]readHistroyMessage];
    }
    if ([action isEqualToString:@"chat"]) {
        dict = dict[@"result"];
        [[MessageBus get] handleReMessage:dict];
    }
    
    if ([action isEqualToString:@"searchFriends"]) {
        [self handleSearchFriends:dict];
    }
    
    if ([action isEqualToString:@"readHistroyMessage"]) {
        [self handleHistroyMessage:dict];
    }
}

-(void)handleHistroyMessage:(NSDictionary *)dict {
    NSArray *array = dict[@"result"];
    for (NSDictionary *dic in array) {
        [self handleReMessage:dic];
    }
}

-(void)handleSearchFriends:(NSDictionary *)dict{
    NSArray *array = dict[@"result"];
    NotificationCenterPost(NOTIFICATION_SearchFriendsResult, array, nil);
}

//接受消息处理，保存到数据
-(void)handleReMessage:(NSDictionary *)dict {

    ChatRecord *chatRecord = [[ChatRecord alloc]init];
    chatRecord.chatRecordType = [dict[@"chatType"]intValue];
    chatRecord.fromUserId = [dict[@"userId"] intValue];
    chatRecord.toUserId = [dict[@"userId"]intValue];
    chatRecord.content = dict[@"content"];
    
    if ([dict[@"sendtime"] isKindOfClass:[NSDate class]]) {
        NSDate *date = dict[@"sendtime"];
        chatRecord.sentTime = [date timeIntervalSince1970];
    }else{
        chatRecord.sentTime = [dict[@"sendtime"] longLongValue];
    }
    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
    chatRecord.state = [dict[@"state"]intValue];
    [[RealmTable get]writeChatRecord:chatRecord];
    NSDictionary *chatRecordDict = @{@"needUpateReadCount":@true,@"chatRecord":chatRecord};
    NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
    NotificationCenterPost(NOTIFICATION_NEWMESSAGE, chatRecord, nil);
}

-(void)handleGetContactList:(NSDictionary *)dict {
    NSArray *contacts =dict[@"result"];
    [[MessageBus get] writeContacts:contacts];
}

-(Contacts *)writeContact:(NSDictionary *)contactDict {
    Contacts *contact = [Contacts create:[contactDict[@"userId"] intValue] icon:contactDict[@"icon"] username:contactDict[@"username"]roomId:contactDict[@"roomId"]];
    [[RealmTable get]writeContact:contact];
    return contact;
}

-(void)writeContacts:(NSArray *)contacts {
    NSMutableArray *contactArr = [[NSMutableArray alloc]init];
    for (NSDictionary *contactDict in contacts) {
        Contacts *contact = [[MessageBus get] writeContact:contactDict];
        [contactArr addObject:contact];
    }
    NotificationCenterPost(NOTIFICATION_RELOADCONTACT,nil , @{@"contact":contactArr});
}

-(NSMutableArray *)readContacts {
    self.contacts = [[RealmTable get]readContacts];
    return self.contacts;
}

-(void)readAllChatRecords {
   self.chatRecords =  [[RealmTable get]readAllChatRecords];
}

-(void)sendChatRecord:(ChatRecord *)chatRecord roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete {
    [[SocketClient get]sayToUser:chatRecord.fromUserId content:chatRecord.content timestamp:chatRecord.sentTime friendId:chatRecord.toUserId roomId:roomId sendComplete:sendComplete];
    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
    [[RealmTable get]writeChatRecord:chatRecord];
}

-(NSMutableArray *)readChatRecordHistory:(NSInteger)userId{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fromUserId = %d OR toUserId = %d",
                         userId, userId];
    
   NSMutableArray *array = [self.chatRecords filteredArrayUsingPredicate:predicate].copy;
    
   return  array;
}
@end
