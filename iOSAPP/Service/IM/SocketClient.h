//
//  SocketClient.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/29.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
typedef NS_ENUM(NSInteger, SOCK_STATUS) {
    SKStatusUnknow,
    SKStatusConnecting,
    SKStatusConnected,
    SKStatusDidDisconnected
};
static NSString *PublicKey = @"team8@bkbedu.com";
static long TAG_HEADER = 100;
static long TAG_BODY = 300;

typedef void(^SendCompleteBlock)(BOOL success);

@interface SocketClient : NSObject <GCDAsyncSocketDelegate> {
    GCDAsyncSocket *clientSocket;
    dispatch_source_t timer;
    BOOL auth;
    NSString *currentIP;
    int currentPort;
    NSInteger reCounter;
}
+ (SocketClient *)get;
@property(nonatomic, strong) NSString *localName;
@property(nonatomic, strong) NSString *privateKey;
@property(nonatomic, strong) NSString *action;
@property(nonatomic, assign) SOCK_STATUS status;
@property(nonatomic, assign) BOOL isBackgound;
@property(nonatomic, assign) BOOL isRedirect;
@property(nonatomic, strong) dispatch_queue_t socketQueue;

- (id)init;

- (NSString *)authKey;

- (void)connect:(NSString *)action;

- (void)disConnect;

- (void)bye;

- (BOOL)isActive;

- (void)stopLiveTimer;

- (void)startLiveTimer;

 -(void)reset;

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (BOOL)reconnect;

-(void) resetDebug;


/**用户登录*/
- (void)login;
/**获取联系人*/
- (void)getContactList;

/**获取历史消息*/
-(void)readHistroyMessage;

/**文本对话*/
- (void)sayToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete;

/**图片*/
- (void)sendImageToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete;

//视频
- (void)sendVideoToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId roomId:(NSString *)roomId sendComplete:(SendCompleteBlock)sendComplete;
//音频
- (void)sendAudioToUser:(NSInteger)uid content:(NSString *)content timestamp:(uint64_t)tval  friendId:(NSInteger )friendId roomId:(NSString *)roomId  sendComplete:(SendCompleteBlock)sendComplete;
//搜索好友
- (void)searchFriends:(int)userId  phoneNum:(NSString *)phoneNum;

- (void)iReadRoomId:(NSString *)rid friendId:(int)friendId;
//管理好友

//好友操作 type:1为添加，2为同意，3为拒绝，4为删除

-(void)manageFriend:(int)userId friendId:(int)friendId type:(int)type;


- (void)sendAck:(NSString *)code params:(NSDictionary *)params;
@end
