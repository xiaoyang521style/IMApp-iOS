//
//  ReadReceiptInfo.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadReceiptInfo : NSObject
/*!
 是否需要回执消息
 */
@property(nonatomic, assign) BOOL isReceiptRequestMessage;

/**
 *  是否已经发送回执
 */
@property(nonatomic,assign) BOOL hasRespond;

/*!
 发送回执的用户ID列表
 */
@property(nonatomic, strong) NSMutableDictionary *userIdList;
@end
