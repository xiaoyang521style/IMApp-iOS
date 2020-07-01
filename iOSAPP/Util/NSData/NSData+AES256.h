//
//  NSData+AES256.h
//  yiqihi.com
//
//  Created by michael on 15/1/8.
//  Copyright (c) 2015年 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES256)
- (NSData *)AES256_Encrypt:(NSString *)key;
- (NSData *)AES256_Decrypt:(NSString *)key;
- (NSString *)base64Encoding;
+ (id)dataWithBase64EncodedString:(NSString *)string;
@end
