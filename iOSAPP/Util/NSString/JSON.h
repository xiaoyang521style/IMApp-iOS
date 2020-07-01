//
//  NSString+Utils.h
//  yiqihi
//
//  Created by xiaoming on 15/10/27.
//  Copyright © 2015年 com.yiqihi.travel. All rights reserved.
//

#ifndef NSString_Utils_h
#define NSString_Utils_h
#endif /* NSString_Utils_h */


#import <Foundation/Foundation.h>

@interface JSON: NSObject

+(id) parse:(NSString *) content;

+(NSMutableDictionary *) parseData:(NSData *) content;

+(NSData *) toData :(NSDictionary *) dict;

+(NSString *) toString:(NSDictionary *) dict;

+ (NSString *)toContent:(NSArray *)items;

+ (id)fromContent:(NSString *)content;


@end
