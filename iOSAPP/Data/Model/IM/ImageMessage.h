//
//  ImageMessage.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MessageContent.h"

@interface ImageMessage : MessageContent <NSCoding>
/*!
 图片消息的URL地址
 
 @discussion 发送方此字段为图片的本地路径，接收方此字段为网络URL地址。
 */
@property(nonatomic, strong) NSString *imageUrl;

@property(nonatomic, strong) NSString *thumbImageUrl;

/*!
 图片消息的缩略图
 */
@property(nonatomic, strong) UIImage *thumbnailImage;

/*!
 是否发送原图
 
 @discussion 在发送图片的时候，是否发送原图，默认值为NO。
 */
@property(nonatomic, getter=isFull) BOOL full;


/*!
 图片消息的原始图片信息
 */
@property(nonatomic, strong) UIImage *originalImage;


/*!
 初始化图片消息
 
 @param image   原始图片
 @param thumbImage   缩略图片
 @return        图片消息对象
 */
+ (instancetype)messageWithImage:(UIImage *)image thumbImage:(UIImage *)thumbImage;


/*!
 初始化图片消息
 
 @param imageURI     原始图片的本地路径
 @param image   缩略图片地址
 @return            图片消息对象
 */
+ (instancetype)messageWithImageURI:(NSString *)imageURI thumbImageURI:(NSString *)thumbImageURI;


@end
