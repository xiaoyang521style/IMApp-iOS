//
//  VideoServer.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/3.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoServer : NSObject
///视频名字
@property (nonatomic,strong) NSString *videoName;

/// 压缩视频
-(void)compressVideo:(NSURL *)path andVideoName:(NSString *)name andSave:(BOOL)saveState
     successCompress:(void(^)(NSData *))successCompress;

/// 获取视频的首帧缩略图
- (UIImage *)imageWithVideoURL:(NSURL *)url;

@end
