//
//  ImageMessage.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ImageMessage.h"

@implementation ImageMessage

/*!
 初始化图片消息
 
 @param image   原始图片
 @return        图片消息对象
 */

+ (instancetype)messageWithImage:(UIImage *)image thumbImage:(UIImage *)thumbImage {
    ImageMessage *imageMessage = [ImageMessage alloc];
    imageMessage.originalImage = image;
    imageMessage.thumbnailImage = image;
    return imageMessage;
}

/*!
 初始化图片消息
 
 @param imageURI    图片的本地路径
 @return            图片消息对象
 */

+ (instancetype)messageWithImageURI:(NSString *)imageURI thumbImageURI:(NSString *)thumbImageURI {
    ImageMessage *imageMessage = [ImageMessage alloc];
    imageMessage.imageUrl = imageURI;
    imageMessage.thumbImageUrl = thumbImageURI;
    return imageMessage;
}
@end
