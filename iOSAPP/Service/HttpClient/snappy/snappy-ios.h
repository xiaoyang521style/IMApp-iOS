//  xiaoming@yiqihi.com modified

@interface NSData (Snappy)

- (NSData *) compressed;
- (NSData *) decompressed;
- (NSString *) decompressedString;

@end

@interface NSString (Snappy)

- (NSData *) compressedString;

@end
