//
//  HttpClient.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponse.h"

typedef void (^HttpResultCallBack)(HttpResponse *response);
typedef void (^HttpCallBack)(BOOL xeach, NSString * message);
typedef void(^UploadProgress)(float uploadProgress);
@interface HttpClient : NSObject

+(void)readServerNodeBlock:(HttpResultCallBack)block;
/**请求短信验证码*/
+(void)getVerificationCode:(NSString *)phoneNumber block:(HttpResultCallBack)block;

/**登录*/
+(void)loginWithPhoneNum:(NSString *)phoneNum code:(NSString *)code block:(HttpResultCallBack)block;

/**上传图片*/
+(void)postImage:(UIImage *)image name:(NSString *)fileName  progress:(UploadProgress)uploadProgress block:(HttpResultCallBack)block;

/**上传文件*/
+(void)postFileData:(NSData *)data name:(NSString *)fileName url:(NSString *)url type:(NSString *)type params:(NSDictionary *)param progress:(UploadProgress)progress block:(HttpResultCallBack)block;

/**上传视频*/
+(void)postVideo:(NSData *)videoData name:(NSString *)fileName progress:(UploadProgress)uploadProgress  block:(HttpResultCallBack)block;

/**上传声音*/
+(void)postVoice:(NSData *)voiceData name:(NSString *)fileName time:(long)time progress:(UploadProgress)uploadProgress  block:(HttpResultCallBack)block;

+(void)loginCheckoutBlock:(HttpResultCallBack)block;

/**上传多张图片*/
+ (void)uploadImages:(NSArray *)images names:(NSArray *)names progress:(UploadProgress)progress  block:(HttpResultCallBack)block;

@end
