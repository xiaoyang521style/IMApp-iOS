//
//  Response.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/23.
//  Copyright © 2018年 赵阳. All rights reserved.
//


#ifndef SocketClient_Response_h
#define SocketClient_Response_h

#import <Foundation/Foundation.h>

@interface Response : NSObject
{
    NSData * retainData;
    NSString *id;
    NSData *bytes;
    SInt32 dataType;
    NSString *content;
    const signed char *currentPosition;
}

+(id)init:(NSData*)data;
-(SInt32) readInt;
-(SInt64) readLong;
-(NSString*) readString;
-(NSData*) readBytes;
-(NSData*) readContent;

@end

#endif

