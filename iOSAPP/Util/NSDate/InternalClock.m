//
//  InternalClock.m
//  yiqihi
//
//  Created by Supery on 15/4/8.
//  Copyright (c) 2015年 com.yiqihi.travel. All rights reserved.
//

#import "InternalClock.h"
#import <mach/mach_time.h>

static InternalClock* instance;

@interface InternalClock(){
    
    uint64_t timebase;
    
    mach_timebase_info_data_t info;
}

@end

@implementation InternalClock

+ (uint64_t)timestampOfMillisecond{
    
    uint64_t now = mach_absolute_time();
    
    uint64_t offset = now - instance->timebase;
    
    uint64_t nanos = (offset * instance->info.numer / instance->info.denom) / NSEC_PER_MSEC;
    
    uint64_t ts = instance->_timestamp + nanos ;
    
    return ts;
}

+ (uint64_t)timestamp{
    
    return [InternalClock timestampOfMillisecond] / 1000;
}

+ (InternalClock *)clock
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        instance = [[InternalClock alloc] init];
        
        if (mach_timebase_info(&instance->info) != KERN_SUCCESS) {
            
            instance->timebase = -1;
        }else{
            
            instance->timebase = mach_absolute_time();
        }
    });
    
    return instance;
}

@end
