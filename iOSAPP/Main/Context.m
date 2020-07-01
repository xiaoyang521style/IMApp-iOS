//
//  Context.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/22.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "Context.h"
#import "Util.h"
static Context *context_instance;
static dispatch_once_t context_once;

@interface Context () {
   NSMutableDictionary *serverNodeDict;
}
@end

@implementation Context

+ (Context *)get {
    dispatch_once(&context_once, ^{
        context_instance = [[Context alloc] init];
    });
    return context_instance;
}

- (id)init {
    if (self = [super init]) {
         _socketLiveTime = 30;
        [self initVersion];
        NSString *content = [self readString:LoginAccount];
        if(content){
           NSDictionary *loginDict = [JSON fromContent:content];
            [self initLogin:loginDict];
        }else{
            [self reset];
        }
        self.serverIP = [self readString:@"serverIP"];
        self.serverPort = [self readInt:@"serverPort"];
        if ([self.token isEqualToString:@""]) {
            self.isLogin = NO;
        }else{
            self.isLogin = YES;
        }
    }
    return self;
}

- (void)initVersion {
    //to 3.8.2 ---->3.82  ;   3.82 ---->3.82
    _versionCode = [[DeviceTool get] parseVersion];
    NSLog(@"version=%lf", _versionCode);
}

- (void)writeLoginAccount:(NSDictionary *)account {
    NSString *content = [JSON toString:account];
    [self writeString:LoginAccount value:content];
}

- (void)initLogin:(NSDictionary *)loginDict{
    _username = [Util stringOf:loginDict fieldName:@"username" defaultValue:@""];
    _token = [Util stringOf:loginDict fieldName:@"token" defaultValue:@""];
    _birthday = [Util dateOf:loginDict fieldName:@"birthday" defaultValue:[NSDate new]];
    _phoneNum = [Util stringOf:loginDict fieldName:@"phoneNum" defaultValue:@""];
    _sex = [Util stringOf:loginDict fieldName:@"sex" defaultValue:@""];
    _icon = [Util stringOf:loginDict fieldName:@"icon" defaultValue:@""];
    _location =  [Util stringOf:loginDict fieldName:@"location" defaultValue:@""];
    _userId = [self readInt:USERID];
}

- (void)reset {
    _token = @"";
    _username = @"";
    _birthday = nil;
    _phoneNum = @"";
    _sex = @"";
    _icon = @"";
    _location =  @"";
    _userId = 0;
}

- (void)logout {
    self.isLogin = NO;
    [self.logoutSubject sendNext:@"退出登录"];
    [[RealmTable get] removeAllDB];
    [self reset];
}

- (NSString *)readLoginAccount {
    NSString *content = [self readString:LoginAccount];
    return content;
}

- (BOOL)readServerNode:(BOOL)logout HttpCallBack:(HttpCallBack)callback {
    typeof(self) weakself=self;
    [HttpClient readServerNodeBlock:^(HttpResponse *response) {
        if (response.isSucess) {
            [weakself handleServerNode:response.result logout:logout];
        }
        if (callback) callback(response.isSucess,[NSString stringWithFormat:@"访问uri,错误:%@",response.message]);
    }];
    return true;
}

-(void) handleServerNode:(NSMutableDictionary *)dict logout:(BOOL)logout{
    if (dict == nil || ([dict objectForKey:@"serverip"]==nil ||[dict objectForKey:@"serverport"]==nil)) {
        return;
    }
    _serverIP = [[NSString alloc] initWithString:[dict objectForKey:@"serverip"]];
    _serverPort = [[dict objectForKey:@"serverport"] intValue];
    [[SocketClient get]connect:@"login"];
    [self writeString:@"serverIP" value:_serverIP];
    [self writeInt:@"serverPort" value:_serverPort];
     [[SocketClient get] startLiveTimer];
    if (logout) return;
    serverNodeDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [self resolveVariables:serverNodeDict];
}

- (void)resolveVariables:(NSMutableDictionary *)dict {
    _socketLiveTime = [[dict objectForKey:@"socketLiveTime"] intValue];
    if (DEBUGMODE) {
        _socketLiveTime = 30;
    }
    _sslEnable=DEBUGMODE?0: [[dict objectForKey:@"sslEnable"] boolValue];
}

-(RACSubject *)loginSubject{
    if (_loginSubject == nil) {
        _loginSubject = [RACSubject subject];
    }
    return _loginSubject;
}

-(RACSubject *)logoutSubject{
    if (_logoutSubject == nil) {
        _logoutSubject = [RACSubject subject];
    }
    return _logoutSubject;
}

- (void)writeString:(NSString *)key value:(NSString *)value {
    [[RealmTable get] writeString:key value:value];
}

- (void)writeInt:(NSString *)key value:(NSInteger)value {
    [[RealmTable get] writeInt:key value:value];
}

- (void)writeDict:(NSString *)key value:(NSDictionary *)value {
    NSString *content = [JSON toString:value];
    [self writeString:key value:content];
}

- (NSString *)readString:(NSString *)key {
    return [[RealmTable get] readString:key];
}

- (NSInteger)readInt:(NSString *)key {
    return [[RealmTable get] readInt:key];
}

- (NSDictionary *)readDict:(NSString *)key {
    NSString *content = [self readString:key];
    if (content == nil) return nil;
    return [JSON parse:content];
}

- (void)removeString:(NSString *)key {
    [[RealmTable get] removeString:key];
}

- (void)removeInt:(NSString *)key {
    [[RealmTable get] removeInt:key];
}

@end
