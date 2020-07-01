//
//  Context.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/22.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Context : NSObject
+ (Context *)get;

@property(nonatomic, assign)BOOL sslEnable;
//app信息
@property(nonatomic, assign)float versionCode;
@property(nonatomic, copy) NSString *serverIP;
@property(nonatomic, assign) int serverPort;
//socket通讯
@property(nonatomic, assign) int socketLiveTime;

//用户信息
@property(nonatomic, assign) int lanuchCount;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSDate *birthday;
@property(nonatomic, copy) NSString *phoneNum;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, assign) NSInteger userId;

@property(nonatomic, assign) int unreadMessageCount;

@property(nonatomic, assign) BOOL socketIsLink;
//是否登录
@property(nonatomic, assign) BOOL isLogin;

//信号
@property(nonatomic, copy) RACSubject *loginSubject;
@property(nonatomic, copy) RACSubject *logoutSubject;
- (void)reset;
/**用户数据保存*/
- (void)writeLoginAccount:(NSDictionary *)account;
/**用户数据初始化*/
- (void)initLogin:(NSDictionary *)loginDict;
/**用户退出数据处理*/
- (void)logout;

- (BOOL)readServerNode:(BOOL)logout HttpCallBack:(HttpCallBack)callback;

- (void)writeString:(NSString *)key value:(NSString *)value;

- (void)writeInt:(NSString *)key value:(NSInteger)value;

- (void)writeDict:(NSString *)key value:(NSDictionary *)value;

- (NSString *)readString:(NSString *)key;

- (NSInteger)readInt:(NSString *)key;

- (NSDictionary *)readDict:(NSString *)key;

- (void)removeString:(NSString *)key;

- (void)removeInt:(NSString *)key;

- (NSString *)readLoginAccount;
@end
