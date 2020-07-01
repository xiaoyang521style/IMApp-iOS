#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *) AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *) AES128DecryptWithMd5Key:(NSString *)key;   //解密
- (NSData *) AES128DecryptWithKey:(NSString *)key;   //解密

@end
