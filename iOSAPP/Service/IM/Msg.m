//
//  Msg.m
//  request
//
//  Created by xiaomichael on 15/1/13.
//  Copyright (c) 2015年 xiaomichael. All rights reserved.
//


#import "Msg.h"
#import "SecurityUtil.h"
#import "snappy-ios.h"

@implementation Msg

-(id)init;
{
    self=[super init];
    buffer=[[NSMutableData alloc] init];
    return self;
}

-(void) dealloc;
{
    [buffer release];
    buffer = nil;
    [super dealloc];
}

-(void)flush
{
    SInt32 v=(SInt32)[buffer length] -4;
    SInt8 bytes[4];
    bytes[0]=(SInt8)((v >> 24) & 0xFF);
    bytes[1]=(SInt8)((v >> 16) & 0xFF);
    bytes[2]=(SInt8)((v >> 8)& 0xFF);
    bytes[3]=(SInt8)(v & 0xFF);
    [buffer replaceBytesInRange:NSMakeRange(0, 4) withBytes:bytes];
}

-(void)writeInt:(SInt32)value
{
    SInt8 bytes[4];
    bytes[0]=(SInt8)((value >> 24) & 0xFF);
    bytes[1]=(SInt8)((value >> 16) & 0xFF);
    bytes[2]=(SInt8)((value >> 8)& 0xFF);
    bytes[3]=(SInt8)(value & 0xFF);
    [buffer appendBytes:&bytes length:4];
}


-(void)writeLong:(SInt64)value
{
    SInt8 bytes[8];
    bytes[0]=(SInt8)((value >> 56) & 0xFF);
    bytes[1]=(SInt8)((value >> 48) & 0xFF);
    bytes[2]=(SInt8)((value >> 40)& 0xFF);
    bytes[3]=(SInt8)((value >> 32)& 0xFF);
    bytes[4]=(SInt8)((value >> 24)& 0xFF);
    bytes[5]=(SInt8)((value >> 16)& 0xFF);
    bytes[6]=(SInt8)((value >> 8)& 0xFF);
    bytes[7]=(SInt8)(value & 0xFF);
    [buffer appendBytes:&bytes length:8];
}


-(void)writeString:(NSString *)value
{
    NSData *data = [value dataUsingEncoding: NSUTF8StringEncoding];
    SInt32 count= (SInt32)[data length];
    [self writeInt:count];
    [buffer appendData:data];
}

-(void)writeContent:(NSString *)value
{
    NSData *data = [value dataUsingEncoding: NSUTF8StringEncoding];
    if ([data length] >=DataPacketLimit){
        [self writeInt:1];
        data= [data compressed];
    }else{
        [self writeInt:0];
    }
    SInt32 count= (SInt32)[data length];
    [self writeInt:count];
    [buffer appendData:data];
}


-(void)writeEncrypt:(NSString *)key Content:(NSString *)value
{
    value=[SecurityUtil encrypt:key content:value];
    [self writeString:value];
}


-(void)writeBytes:(NSData *) value
{
    [buffer appendData:value];
}


-(NSData*) getBuffer
{
    NSData *result=[NSData dataWithData:buffer];
    return result;
}

@end


