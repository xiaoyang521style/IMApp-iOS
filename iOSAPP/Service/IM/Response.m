//
//  Response.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/23.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "Response.h"
#import "snappy-ios.h"
#import <CoreFoundation/CFByteOrder.h>

@interface Response (Private)

-(id)initWithData:(NSData*)initData;
-(NSException *) ReadException;
-(void)skipNumberOfBytes:(NSUInteger)count;

@end


@implementation Response (Private)

-(id)initWithData:(NSData*)initData
{
    self = [super init];
    if (self != nil)
    {
        retainData = [initData retain];
        currentPosition = (const SInt8 *)retainData.bytes;
    }
    return self;
}

-(void)dealloc
{
    [retainData release];
    retainData = nil;
    [super dealloc];
}

-(NSException *)ReadException
{
    return [NSException exceptionWithName:@"size overflow" reason:@"the postion is large than data." userInfo:nil];
}

- (void)skipNumberOfBytes:(NSUInteger)numberOfBytes
{
    currentPosition += numberOfBytes;
}

@end


@implementation Response

+(id)init:(NSData*)data
{
    return [[[Response alloc] initWithData:data] autorelease];
}

-(SInt32) readInt
{
    const SInt32 *dword = (const SInt32 *) currentPosition;
    [self skipNumberOfBytes:sizeof(SInt32)];
    return CFSwapInt32BigToHost(*dword);
}


-(SInt64) readLong
{
    const SInt64 *dword = (const SInt64 *) currentPosition;
    [self skipNumberOfBytes:sizeof(SInt64)];
    return CFSwapInt64BigToHost(*dword);
}

-(NSString*) readString
{
    SInt32 size=self.readInt;
    NSString *result = [[NSString alloc] initWithBytes:(const void *)currentPosition length:size encoding:NSUTF8StringEncoding];
    [self skipNumberOfBytes:size];
    return [result autorelease];
}

-(NSData*) readBytes {
    SInt32 size=self.readInt;
    NSData* result = [NSData dataWithBytes:currentPosition length:size];
    [self skipNumberOfBytes:(size)];
    return result;
}

-(NSData*) readContent
{
    SInt32 compressMode=self.readInt;
    SInt32 size=self.readInt;
    NSData *result = [NSData dataWithBytes:currentPosition length:size];
    [self skipNumberOfBytes:(size)];
    if (compressMode==1){
        result=[result decompressed];
    }
    return result;
}

@end
