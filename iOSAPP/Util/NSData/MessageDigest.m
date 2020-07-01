#import "MessageDigest.h"

@implementation MessageDigest


- (id)init
{
    self = [super init];

    if (self == nil)
    {
        return nil;
    }

    [self reset];

    return self;
}


- (void)reset
{
    // Subclasses should override this method.
}


- (int)updateWith:(const void *)data length:(CC_LONG)length
{
    // Subclasses should override this method.
    return 0;
}


- (int)updateWithString:(NSString *)string
{
    if (string == nil)
    {
        return 0;
    }

    // Convert the given 'NSString *' to 'const char *'.
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];

    // Check if the conversion has succeeded.
    if (str == NULL)
    {
        return 0;
    }

    // Get the length of the C-string.
    CC_LONG len = strlen(str);

    if (len == 0)
    {
        return 0;
    }

    return [self updateWith:str length:len];
}


- (int)updateWithBool:(BOOL)data
{
    return [self updateWith:(const void *)&data length:sizeof(BOOL)];
}


- (int)updateWithChar:(char)data
{
    return [self updateWith:(const void *)&data length:sizeof(char)];
}


- (int)updateWithShort:(short)data
{
    return [self updateWith:(const void *)&data length:sizeof(short)];
}


- (int)updateWithInt:(int)data
{
    return [self updateWith:(const void *)&data length:sizeof(int)];
}


- (int)updateWithLong:(long)data
{
    return [self updateWith:(const void *)&data length:sizeof(long)];
}


- (int)updateWithLongLong:(long long)data
{
    return [self updateWith:(const void *)&data length:sizeof(long long)];
}


- (int)updateWithFloat:(float)data
{
    return [self updateWith:(const void *)&data length:sizeof(float)];
}


- (int)updateWithDouble:(double)data
{
    return [self updateWith:(const void *)&data length:sizeof(double)];
}


- (unsigned char *)final
{
    // Subclasses should override this method.
    return NULL;
}


- (unsigned char *)buffer
{
    // Subclasses should override this method.
    return NULL;
}


- (size_t)bufferSize
{
    // Subclasses should override this method.
    return 0;
}


@end
