//
//  VoicePlayer.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatVoicePlayer : NSObject
+(ChatVoicePlayer *)sharePlayer;
-(void)playVoiceWithData:(NSData *)data didFinish:(void (^)(void))didFinish;
-(void)endPlay;
@end
