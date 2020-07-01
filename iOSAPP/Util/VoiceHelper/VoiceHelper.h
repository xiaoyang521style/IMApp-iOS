//
//  VoiceHelper.h
//  yiqihi
//
//  Created by Supery on 15/3/30.
//  Copyright (c) 2015年 com.yiqihi.travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceHelper : NSObject

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath;

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath;

@end
