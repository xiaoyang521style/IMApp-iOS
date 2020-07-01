//
//  Msg.h
//  request
//
//  Created by xiaomichael on 15/1/13.
//  Copyright (c) 2015年 xiaomichael. All rights reserved.
//

#ifndef client_msg_h
#define client_msg_h
#define DataPacketLimit 1024

#import <Foundation/Foundation.h>

typedef enum{
    none=0x0,
    snappy=0x1
}  Compress;

typedef enum {
    json=0x0,
    bytes=0x1,
    string=0x2,
    error=0x3
} DataType;


typedef enum{
    mobile=0x3,
    tablet=0x4,
    android=0x5,
    ios=0x6
} Device;

typedef enum{
    app =0x1
} Scope;

typedef enum{
    mobileService = 0x31
} Service;

typedef enum{
    socket1 = 0x1
} Version;

typedef enum{
    handlesocket=0x21
} Action;

typedef enum{
    asyncMode=0x0,
    syncMode=0x1
} SocketMode;


@interface Msg :NSObject
{
    
    NSMutableData *buffer;
}

-(id)init;
-(void)writeInt:(SInt32)value;
-(void)writeLong:(SInt64)value;
-(void)writeString:(NSString *)value;
-(void)writeContent:(NSString *)value;
-(void)writeEncrypt:(NSString *)key Content:(NSString *)value;
-(void)writeBytes:(NSData *) value;
-(NSMutableData*) getBuffer;
-(void)dealloc;
-(void)flush;


@end

#endif





