//
//  VideoMessage.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/3.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MessageContent.h"

@interface VideoMessage : MessageContent <NSCoding>
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *videoUrl;
@property(nonatomic, strong) UIImage *thumbnailImage;
+(instancetype)messageWithVideoURI:(NSString *)videoUri imageURI:(NSString *)imageUri;
@end
