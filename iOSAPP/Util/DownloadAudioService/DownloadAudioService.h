//
//  DownloadAudioService.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadAudioService : NSObject
typedef void(^FinishBlock)(NSString *filePath);
typedef void(^Failed)();
/*
 * url                  音频网址
 * directoryPath  存放的地址
 * fileName         要存的名字
 */
+ (void)downloadAudioWithUrl:(NSString *)url
           saveDirectoryPath:(NSString *)directoryPath
                    fileName:(NSString *)fileName
                      finish:(FinishBlock )finishBlock
                      failed:(Failed)failed;
@end
