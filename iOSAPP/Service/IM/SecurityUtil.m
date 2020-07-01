#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "snappy-ios.h"

@implementation SecurityUtil

#pragma mark - base64


+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [base64String autorelease];
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [base64String autorelease];
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [base64String autorelease];
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [base64String autorelease];
}


#pragma mark - AES加密
+(NSData*)encryptCloud:(NSString*)password data:(NSData*)data
{
    NSData *encryptedData = [data AES128EncryptWithKey:password];
    return [encryptedData compressed];
}

+(NSString*)encrypt:(NSString*)password content:(NSString*)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data AES128EncryptWithKey:password];
    content=[SecurityUtil encodeBase64Data:encryptedData];
    return content;
}

#pragma mark - AES解密

+(NSData*)decryptCloud:(NSString*)password data:(NSData*)data
{
    data =[data decompressed];
    NSData *decryData = [data AES128DecryptWithKey:password];
    return decryData;
}

+(NSString*)decryptString:(NSString*)password  content:(NSString*)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
  return [SecurityUtil decryptString:password
                                data:data];
}

+(NSString*)decryptString:(NSString*)password  data:(NSData*)data
{
    NSData *base64Data = [GTMBase64 decodeData:data];
    NSData *decryData = [base64Data AES128DecryptWithKey:password];
    
    NSString *decryString = [[[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding] autorelease];
    return decryString;
}


+(NSData*)decryptBytes:(NSString*)password  content:(NSString*)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [GTMBase64 decodeData:data];
    NSData *decryData = [base64Data AES128DecryptWithMd5Key:password];
    return decryData;
}

+(NSData*)decryptBytes:(NSString*)password  data:(NSData*)bytes
{
    NSData *base64Data = [GTMBase64 decodeData:bytes];
    NSData *decryData = [base64Data AES128DecryptWithMd5Key:password];
    return decryData;
}

@end
