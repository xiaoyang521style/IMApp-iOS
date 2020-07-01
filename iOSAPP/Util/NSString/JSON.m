//
//  NSString+Utils.m
//  yiqihi
//
//  Created by xiaoming on 15/10/27.
//  Copyright © 2015年 com.yiqihai.travel. All rights reserved.
//

#import "JSON.h"

@implementation JSON


+ (id)parse:(NSString *)content {
    if (content == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
    return json;
}

+ (NSMutableDictionary *)parseData:(NSData *)content {
    if (content == nil) {
        return nil;
    }
    NSError *err;
    NSMutableDictionary *response;
    response = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:&err];
    return response;
}

+ (NSData *)toData:(NSDictionary *)dict {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    return jsonData;
}

+ (NSString *)toString:(NSDictionary *)dict {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return content;
}


+ (NSString *)toContent:(NSArray *)items; {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:items options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return content;
}


+ (id)fromContent:(NSString *)content; {
    NSError *error;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return parsedData;
}


@end
