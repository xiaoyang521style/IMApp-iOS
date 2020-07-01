//
//  HttpResponse.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//
typedef NS_ENUM(NSInteger, ErrorCode) {
    RESULT_SUCCEEDED,
    RESULT_NO_NETWORK = -1009,
    RESULT_NETWORK_FAILED = -1004,
    RESULT_INVALID_TOKEN = 99999,
};
#import <Foundation/Foundation.h>

@interface HttpResponse : NSObject
@property(nonatomic, strong) NSString *message;
@property(nonatomic, assign) BOOL isSucess;
@property(nonatomic, assign) id result;
- (void)initWith:(NSMutableDictionary *)dict;

+ (instancetype)responseWithError:(NSError *)error;

+ (instancetype)responseWithDict:(NSMutableDictionary *)dict;

+ (instancetype)responseWithData:(NSData*)data ;
@end
