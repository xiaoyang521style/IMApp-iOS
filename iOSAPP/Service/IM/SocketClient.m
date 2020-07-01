//
//  SocketClient.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/29.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SocketClient.h"
#import "SecurityUtil.h"
#import "Msg.h"
#import "NSString+HI.h"
#import "Response.h"
#define SOCK_TIMEOUT -1
static SocketClient *socket_instance;
static dispatch_once_t socket_once;

@class GCDAsyncSocket;

@implementation SocketClient

@synthesize privateKey;
@synthesize localName;

+ (SocketClient *)get {
    dispatch_once(&socket_once, ^{
        socket_instance = [[SocketClient alloc] init];
    });
    return socket_instance;
}

- (id)init {
    if (self = [super init]) {
        _socketQueue = dispatch_queue_create("SocketQueue", DISPATCH_QUEUE_CONCURRENT);
        clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        clientSocket.IPv4PreferredOverIPv6 = NO;
        timer = nil;
        UIDevice *deviceInfo = [UIDevice currentDevice];
        self.localName = deviceInfo.name;
        _isRedirect = false;
        _action = @"connect";
        auth = false;
        self.privateKey = @"";
        self.status = SKStatusUnknow;
       
    }
    return self;
}
- (void)bye {
    NSMutableDictionary *oReq = [NSMutableDictionary dictionary];
    //[oReq setValue:[Context get].cookieId forKey:@"cookieId"];
    [oReq setValue:@"bye" forKey:@"action"];
    //[oReq setValue:[[Context get] deviceId] forKey:@"deviceId"];
    NSString *content = [JSON toString:oReq];
    content = [SecurityUtil encrypt:[self authKey] content:content];
    Msg *msg = [self newMsg:content];
    [self send:msg];
}
- (void)dealloc {
   [super dealloc];
    clientSocket = nil;
    [self stopLiveTimer];
    self.status = SKStatusUnknow;
}
- (void)reset {
    _isRedirect = false;
    reCounter = 0;
}
//心跳
- (void)startLiveTimer {
    [self stopLiveTimer];
    int interval = [Context get].socketLiveTime;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _socketQueue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        [self keepAlive];
    });
    dispatch_resume(timer);
}
- (void)stopLiveTimer {
    if (!timer) return;
    dispatch_source_cancel(timer);
    timer = nil;
}

- (void)keepAlive {
    if (_status != SKStatusConnected || [self isActive] == false || [Context get].userId == 0) return;
    NSLog(@"KeepAlive");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"live" forKey:@"action"];
    NSString *content = [JSON toString:dict];
    content = [SecurityUtil encrypt:[self authKey] content:content];
    Msg *msg = [self newMsg:content];
    [self send:msg];
}
- (BOOL)isActive {
    return clientSocket != nil && [clientSocket isConnected];
}

- (void)disConnect {
    reCounter = 0;
    [clientSocket disconnect];
    NSLog(@"Disconnect");
}


- (void)connect:(NSString *)action {
    if ([self isActive]) return;
    NSString *lastSocketIP = [[Context get] readString:SocketIP];
    NSString *lastSocketPort = [[Context get] readString:SocketPort];
    if (currentIP){
        currentIP=nil;
    }
    if (DEBUGMODE) {
        currentIP = [DebugSocketServer copy];
        currentPort = DebugSocketPort ;
    } else {
        currentIP =[[Context get].serverIP copy];
        if (lastSocketIP && ([lastSocketIP isEqualToString:currentIP] == false)) {
            currentPort = [Context get].serverPort;
        } else if ((![NSString isEmpty:lastSocketPort]) && lastSocketPort.length >= 4) {
            currentPort = [lastSocketPort intValue];
        } else {
            currentPort = [Context get].serverPort;
        }
    }
    self.action = [action copy];
    NSError *err;
    if (!clientSocket.isConnected && ![clientSocket connectToHost:currentIP onPort:currentPort withTimeout:60 error:&err]) {
        NSLog(@"connect error %ld->%@", (long) err.code, err.localizedDescription);
        self.status = SKStatusDidDisconnected;
        NotificationCenterPost(NOTIFICATION_SOCK_STATUS, @(self.status), nil);
    } else {
        NSLog(@"Connecting ip=%@ port=%lu", currentIP, (long) currentPort);
        self.status = SKStatusConnecting;
       NotificationCenterPost(NOTIFICATION_SOCK_STATUS, @(self.status), nil);
    }
}
-(void) resetDebug{
    currentIP=DebugSocketServer;
}

- (BOOL)reconnect {
    NSError *err;
    auth = false;
    privateKey = @"";
    _action = @"reconnect";
    if ([clientSocket connectToHost:currentIP onPort:currentPort withTimeout:20 error:&err]) {
        NSLog(@"Reconnecting ip=%@ port=%d", currentIP, currentPort);
        self.status = SKStatusConnecting;
       NotificationCenterPost(NOTIFICATION_SOCK_STATUS, @(self.status), nil);
        return YES;
    } else {
        NSLog(@"connect error %ld->%@", (long) err.code, err.localizedDescription);
       
        self.status = SKStatusDidDisconnected;
       NotificationCenterPost(NOTIFICATION_SOCK_STATUS, @(self.status), nil);
        return NO;
    }
}
- (NSString *)authKey {
    if (auth && [self.privateKey isKindOfClass:[NSString class]] && self.privateKey.length > 0) {
        return self.privateKey;
    } else {
        return PublicKey;
    }
}

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag {
    [clientSocket writeData:data withTimeout:timeout tag:tag];
}
- (void)readDataHeader {
   [clientSocket readDataToLength:4 withTimeout:-1 tag:TAG_HEADER];
}

- (void)readDataBody:(SInt32)size {
   [clientSocket readDataToLength:size withTimeout:-1 tag:TAG_BODY];
}

#pragma mark socket delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"Connected!");
   
    [[Context get] writeString:SocketIP value:host];
    [[Context get] writeString:SocketPort value:[NSString stringWithFormat:@"%lu", (long) port]];
    reCounter = 0;
    _status = SKStatusConnected;
    NotificationCenterPost(NOTIFICATION_SOCK_STATUS, @(self.status), nil);
    [self readDataHeader];
    BOOL isLogin = ([_action isEqualToString:@"login"]) || ([_action isEqualToString:@"switchPort"]);
    BOOL isReconnect = [_action isEqualToString:@"reconnect"];
    if (isLogin == false && isReconnect == false) {
      return;
    }
   if (![[Context get].token isEqualToString:@""] && _isRedirect == false) {
        [self login];
   }
    [self login];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socketDidDisconnect=%ld", (long) reCounter);
    self.status = SKStatusDidDisconnected;
    NotificationCenterPost(NOTIFICATION_SOCK_STATUS, @(self.status), nil);
    if (_isRedirect || (_isBackgound == false && [Context get].userId != 0)) {
        [self autoConnect];
    } else {
        self.privateKey = @"";
        auth = NO;
    }
}
- (void)autoConnect {
    if (reCounter > 3) {
        reCounter = 0;
        return;
    }
    [self reconnect];
    reCounter++;
}

- (void)switchPort:(int)port {
    currentPort = (int) port;
    _isRedirect = true;
    _action = @"switchPort";
    [[Context get] reset];
    [self disConnect];
}

// 接收到数据（可以通过tag区分）
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
     NSLog(@"tag ======== %ld",tag);
   Response *response = nil;
   if (tag == TAG_HEADER) {
      const SInt32 *dword = (const SInt32 *) data.bytes;
      int bodyLength = CFSwapInt32BigToHost(*dword);
      [self readDataBody:bodyLength];
   }else if (tag == TAG_BODY) {
      response = [Response init:data];
      SInt32 dataType = [response readInt];
      NSString *jobId = [response readString];
      NSString *jobTag = [response readString];
      SInt32 jobDevice = [response readInt];
      NSData *bytes;
      {
         bytes = [response readContent];
         NSString *content = [[NSString alloc] initWithData:bytes encoding:NSUTF8StringEncoding];
         NSDictionary *dict = [JSON parse:content];
         [content release];
         if (dict) {
            NSString *json;
            NSString *data = [dict objectForKey:@"data"];
            json = [SecurityUtil decryptString:PublicKey content:data];
            if (data && data.length > 0) {
                if (json) {
                    dict = [JSON parse:json];
                   NSLog(@"dict === %@",dict);
                   if ([dict[@"xeach"] boolValue]) {
                      [[MessageBus get] handleMessage:dict];
                   }
                }
            }
         }
      }
      [self readDataHeader];
   } else {
      
   }
}

/*
 发送回执消息，与服务器同步数据
 code: readMessages
 params:  [@"msgId":string,@"timestamp":long]
 -------------------
 */
- (void)sendAck:(NSString *)code params:(NSDictionary *)params {
    
}

- (Msg *)newMsg:(NSString *)content {
    return [self newMsg:@"msgId" msgTag:@"msgTag" msgTo:@"msgTo" Content:content];
}

- (Msg *)newMsg:(NSString *)msgId
         msgTag:(NSString *)msgTag msgTo:(NSString *)msgTo
        Content:(NSString *)content {
    Msg *msg = [[Msg alloc] init];
    [msg writeInt:(SInt32) 0];
    [msg writeInt:(SInt32) 19750];
    [msg writeInt:(SInt32) 424];
    [msg writeInt:(SInt32) 0];
    [msg writeInt:(SInt32) 6];
    [msg writeString:localName];
    [msg writeString:[[NSNumber numberWithLong:[Context get].userId] stringValue]];
    [msg writeString:@"ios"];//serviceName
    [msg writeInt:(SInt32) 31];//service
    [msg writeInt:(SInt32) 1];//scope
    [msg writeInt:(SInt32) 21];//action
    [msg writeInt:(SInt32) 1];//version
    [msg writeInt:(SInt32) 0];//mode
    [msg writeString:@"msgId"];//msgId
    [msg writeString:@"msgTag"];//msgTag
    [msg writeString:@"msgTo"];//msgTo
    SInt64 timestamp = [[NSDate date] timeIntervalSince1970];
    [msg writeLong:timestamp];//timestamp
    [msg writeContent:content];
    [msg flush];
    return msg;
}


- (void)send:(Msg *)msg{
    if ([self isActive]) {
        [clientSocket writeData:[msg getBuffer] withTimeout:SOCK_TIMEOUT tag:0];
    } else {
        [self reconnect];
    }
}

//登录
- (void)login {
    NSMutableDictionary *oReq = [NSMutableDictionary dictionary];
    [oReq setValue:@([Context get].userId) forKey:@"userId"];
    [oReq setValue:[Context get].token forKey:@"token"];
    [oReq setValue:@"login" forKey:@"action"];
    NSString *content = [JSON toString:oReq];
    content = [SecurityUtil encrypt:[self authKey] content:content];
    Msg *msg = [self newMsg:content];
    [self send:msg];
   [msg release];
   msg = nil;
}

//获取历史消息
-(void)readHistroyMessage {
   NSMutableDictionary *oReq = [NSMutableDictionary dictionary];
   [oReq setValue:@([Context get].userId) forKey:@"userId"];
   [oReq setValue:@"readHistroyMessage" forKey:@"action"];
   NSString *content = [JSON toString:oReq];
   content = [SecurityUtil encrypt:[self authKey] content:content];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
   msg = nil;
}

//获取联系人
-(void)getContactList{
   NSMutableDictionary *oReq = [NSMutableDictionary dictionary];
   [oReq setValue:[Context get].token forKey:@"token"];
   [oReq setValue:@([Context get].userId) forKey:@"userId"];
   [oReq setValue:@"getContactList" forKey:@"action"];
   NSString *content = [JSON toString:oReq];
   content = [SecurityUtil encrypt:[self authKey] content:content];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
   msg = nil;
}

//对话 文本
- (void)sayToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete {
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:
                                 @{@"action":@"chat",
                                   @"chatType": @(ChatRecordTypeText),
                                   @"content": content,
                                   @"sendtime": @(tval),
                                   @"userId": @(uid),
                                   @"friendId":@(friendId),
                                   @"state":@(0),
                                   @"roomId":roomId
                                   }];
    NSString *txt = [JSON toString:para];
    content = [SecurityUtil encrypt:[self authKey] content:txt];
    Msg *msg = [self newMsg:content];
    [self send:msg];
    [msg release];
    msg = nil;
    if (sendComplete)
        sendComplete(YES);
}

//对话 图片
- (void)sendImageToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId  roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete {
   NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:
                                @{@"action":@"chat",
                                  @"chatType": @(ChatRecordTypeImage),
                                  @"content": content,
                                  @"sendtime": @(tval),
                                  @"userId": @(uid),
                                  @"friendId":@(friendId),
                                  @"state":@(0),
                                  @"roomId":roomId
                                  }];
   NSString *txt = [JSON toString:para];
   content = [SecurityUtil encrypt:[self authKey] content:txt];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
    msg = nil;
   if (sendComplete)
      sendComplete(YES);
}

//对话语音
- (void)sendAudioToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId  roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete {
   NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:
                                @{@"action":@"chat",
                                  @"chatType": @(ChatRecordTypeAudio),
                                  @"content": content,
                                  @"sendtime": @(tval),
                                  @"userId": @(uid),
                                  @"friendId":@(friendId),
                                  @"state":@(0),
                                  @"roomId":roomId
                                  }];
   
   NSString *txt = [JSON toString:para];
   content = [SecurityUtil encrypt:[self authKey] content:txt];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
   msg = nil;
   if (sendComplete)
      sendComplete(YES);
}

//视频
- (void)sendVideoToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete {
   NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:
                                @{@"action":@"chat",
                                  @"chatType": @(ChatRecordTypeVideo),
                                  @"content": content,
                                  @"sendtime": @(tval),
                                  @"userId": @(uid),
                                  @"friendId":@(friendId),
                                  @"state":@(0),
                                  @"roomId":roomId
                                  }];
   
   NSString *txt = [JSON toString:para];
   content = [SecurityUtil encrypt:[self authKey] content:txt];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
   msg = nil;
   if (sendComplete)
      sendComplete(YES);
}

//搜索好友
- (void)searchFriends:(int)userId  phoneNum:(NSString *)phoneNum{
   NSMutableDictionary *oReq = [NSMutableDictionary dictionary];
   [oReq setValue:@"searchFriends" forKey:@"action"];
   [oReq setValue:@(userId) forKey:@"userId"];
   [oReq setValue:phoneNum forKey:@"phoneNum"];
   NSString *content = [JSON toString:oReq];
   content = [SecurityUtil encrypt:[self authKey] content:content];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
   msg = nil;
}
//发送已阅读通知
- (void)iReadRoomId:(NSString *)rid friendId:(int)friendId {
   NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"action": @"iRead", @"roomId": rid,@"friendId":@(friendId)}];
   NSString *txt = [JSON toString:para];
   txt = [SecurityUtil encrypt:[self authKey] content:txt];
   Msg *msg = [self newMsg:txt];
   [self send:msg];
   [msg release];
   msg = nil;
}
//好友操作 type:1为添加，2为同意，3为拒绝，4为删除
-(void)manageFriend:(int)userId friendId:(int)friendId type:(int)type{
   NSMutableDictionary *oReq = [NSMutableDictionary dictionary];
   [oReq setValue:@"manageFriend" forKey:@"action"];
   [oReq setValue:@(type) forKey:@"type"];
   [oReq setValue:@(userId) forKey:@"userId"];
   [oReq setValue:@(friendId) forKey:@"friendId"];
   NSString *content = [JSON toString:oReq];
   content = [SecurityUtil encrypt:[self authKey] content:content];
   Msg *msg = [self newMsg:content];
   [self send:msg];
   [msg release];
   msg = nil;
}


@end
