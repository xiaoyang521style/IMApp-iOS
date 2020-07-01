//  xiaoming@yiqihi.com modified

#import "snappy-c.h"
#import "snappy-ios.h"


@implementation NSData (Snappy)

- (NSData *) compressed {
    size_t clen=snappy_max_compressed_length(self.length);
    char *buffer = malloc(clen);
    snappy_compress(self.bytes,self.length, buffer,&clen);
    NSData* data = [NSData dataWithBytes:buffer length:clen];
    free(buffer);
    return data;
}

- (NSData *) decompressed {
    size_t ulen;
    snappy_uncompressed_length(self.bytes, self.length, &ulen);
    char *buffer = malloc(ulen);
    snappy_uncompress(self.bytes, self.length, buffer,&ulen);
    NSData* data = [NSData dataWithBytes:buffer length:ulen];
    free(buffer);
    return data;
    
}

- (NSString *) decompressedString {
    return [[NSString alloc] initWithData:[self decompressed]
                                 encoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (Snappy)

- (NSData *) compressedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] compressed];
}

@end
