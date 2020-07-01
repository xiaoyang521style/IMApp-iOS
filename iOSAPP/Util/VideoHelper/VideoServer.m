//
//  VideoServer.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/3.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "VideoServer.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation VideoServer
//压缩视频
-(void)compressVideo:(NSURL *)path andVideoName:(NSString *)name andSave:(BOOL)saveState
     successCompress:(void(^)(NSData *))successCompress  //saveState 是否保存视频到相册
{
    self.videoName = name;
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = [self compressedURL];//设置压缩后视频流导出的路径
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                //NSLog(@"视频压缩成功,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
                if (saveState) {
                    [self saveVideo:[self compressedURL]];//保存视频到相册
                }
                //压缩成功视频流回调回去
                successCompress([NSData dataWithContentsOfURL:[self compressedURL]].length > 0?[NSData dataWithContentsOfURL:[self compressedURL]]:nil);
            }else{
                //压缩失败的回调
                successCompress(nil);
            }
        }];
    }
}
#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.videoName]]];
}

#pragma mark 计算视频大小
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

#pragma mark 保存视频到相册
- (void)saveVideo:(NSURL *)outputFileURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            //(@"保存视频失败:%@",error);
        } else {
            //NSLog(@"保存视频到相册成功");
        }
    }];
}

/**
*  通过视频的URL，获得视频缩略图
*  @param url 视频URL
*  @return首帧缩略图
*/
#pragma mark 获取视频的首帧缩略图
- (UIImage *)imageWithVideoURL:(NSURL *)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    // 根据asset构造一张图
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
    generator.appliesPreferredTrackTransform = YES;
    // 设置图片的最大size(分辨率)
    generator.maximumSize = CGSizeMake(600, 450);
    NSError *error = nil;
    // 根据时间，获得第N帧的图片
    // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10000) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}
@end
