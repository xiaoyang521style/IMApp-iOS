#import "NSData+AES.h"
#import "MD5.h"
#include <CommonCrypto/CommonCryptor.h>

@implementation NSData (Encryption)

-(NSData *)AES128EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          nil,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES128DecryptWithKey:(NSString *)key {//解密
    NSData *keyData=[ key dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [keyData bytes],
                                          kCCBlockSizeAES128,
                                          [keyData bytes],
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData * data=[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return data;
    }
    free(buffer);
    return nil;
}


- (NSData *)AES128DecryptWithMd5Key:(NSString *)key {//解密
    MD5 *md = [MD5 md5WithString:key];
    NSData *keyData=[NSData dataWithBytes:[md buffer] length:CC_MD5_DIGEST_LENGTH];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [keyData bytes],
                                          kCCBlockSizeAES128,
                                          [keyData bytes],
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData * data=[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return data;
    }
    free(buffer);
    return nil;
}

@end
