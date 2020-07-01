//
//  InternalClock.h
//  yiqihi
//
//  Created by Supery on 15/4/8.
//  Copyright (c) 2015年 com.yiqihi.travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternalClock : NSObject

@property(nonatomic, assign) uint64_t timestamp;

+ (InternalClock *)clock;

/**
 *  时间戳以秒返回
 *
 *  @return 秒
 */
+ (uint64_t)timestamp;


/**
 *  时间戳以毫秒返回
 *
 *  @return 毫秒
 */
+ (uint64_t)timestampOfMillisecond;

@end
