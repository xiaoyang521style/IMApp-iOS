#import "MessageDigest.h"


@interface MD5 : MessageDigest
+ (MD5 *)md5WithString:(NSString *)string;
@end
