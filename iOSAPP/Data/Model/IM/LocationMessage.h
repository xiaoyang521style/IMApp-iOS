//
//  LocationMessage.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MessageContent.h"

@interface LocationMessage : MessageContent <NSCoding>
/*!
 地理位置的二维坐标
 */
@property(nonatomic, assign) CLLocationCoordinate2D location;

/*!
 地理位置的名称
 */
@property(nonatomic, strong) NSString *locationName;

/*!
 地理位置的缩略图
 */
@property(nonatomic, strong) UIImage *thumbnailImage;

/*!
 初始化地理位置消息
 
 @param image 地理位置的缩略图
 @param location 地理位置的二维坐标
 @param locationName 地理位置的名称
 @return 地理位置消息的对象
 */
+ (instancetype)messageWithLocationImage:(UIImage *)image
                                location:(CLLocationCoordinate2D)location
                            locationName:(NSString *)locationName;
@end
