#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64

+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密

//将string转成带密码的data
+ (NSString*)encrypt:(NSString*)password content:(NSString*)content ;

//将带密码的data转成string
+(NSString*)decryptString:(NSString*)password content:(NSString*)content ;
+(NSString*)decryptString:(NSString*)password data:(NSData*)content ;

+(NSData*)decryptBytes:(NSString*)password  content:(NSString*)content;
+(NSData*)decryptBytes:(NSString*)password  data:(NSData*)bytes;

+(NSData*)decryptCloud:(NSString*)password data:(NSData*)data;
+(NSData*)encryptCloud:(NSString*)password data:(NSData*)data;


@end
