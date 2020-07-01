//
//  HttpResponse.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "HttpResponse.h"
#import "Util.h"
#import "JSON.h"

@implementation HttpResponse

- (instancetype)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)initWith:(NSMutableDictionary *)dict {
    self.isSucess = [Util boolOf:dict fieldName:@"xeach" defaultValue:true];
    self.message = [Util stringOf:dict fieldName:@"message" defaultValue:self.isSucess?@"":@"未知错误"];
    self.result = dict[@"result"];
}

+ (instancetype)responseWithError:(NSError *)error {
    HttpResponse *response = [[HttpResponse alloc] init];
    response.isSucess = false;
    response.result = nil;
    if (error.code == RESULT_NO_NETWORK || error.code == RESULT_NETWORK_FAILED) {
        response.message = @"网络不给力,请稍后重试!";
    } else {
        response.message = [error localizedDescription];
    }
    return response;
}

+ (instancetype)responseWithDict:(NSMutableDictionary *)dict {
    HttpResponse *response = [[HttpResponse alloc] init];
    [response initWith:dict];
    return response;
}

+ (instancetype)responseWithData:(NSData*)data {
    NSMutableDictionary *dict =[JSON parseData:data];
    return [HttpResponse responseWithDict:dict];
}

@end
