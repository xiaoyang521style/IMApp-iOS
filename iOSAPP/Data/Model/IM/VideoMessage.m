//
//  VideoMessage.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/3.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "VideoMessage.h"

@implementation VideoMessage

+(instancetype)messageWithVideoURI:(NSString *)videoUri imageURI:(NSString *)imageUri {
    VideoMessage *videoMessage = [VideoMessage new];
    videoMessage.imageUrl = imageUri;
    videoMessage.videoUrl = videoUri;
    return videoMessage;
}

@end
