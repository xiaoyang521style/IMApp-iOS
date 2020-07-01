//
//  NSString+md5.m
//  Oxen
//
//  Created by lanbiao on 14-6-26.
//  Copyright (c) 2014年 yiqihi.com. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (md5)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
