//
//  HttpClient.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "HttpClient.h"
#import <SMS_SDK/SMSSDK.h>
#import "UIImage+ScaleImage.h"
@implementation HttpClient

+(NSString *)restUri:(NSString *)command {
    NSString *uri;
    if(DEBUGMODE){
        uri = [NSString stringWithFormat:@"%@/%@",DebugRestServer,command];
    }else{
        //线上服务器地址
        uri = [NSString stringWithFormat:@"%@/%@",RestServer,command];
    }
    return uri;
}

/**读取服务器配置*/
+(void)readServerNodeBlock:(HttpResultCallBack)block {
    NSString *uri = [HttpClient restUri:@"readServerNode"];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ios" forKey:@"device"];
    [params setObject:@([Context get].versionCode) forKey:@"version"];
    [HttpClient postUri:uri params:params block:block];
}

/**请求短信验证码*/
+(void)getVerificationCode:(NSString *)phoneNumber block:(HttpResultCallBack)block {
    //不带自定义模版
    __block HttpResponse *httpResponse = nil;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS  phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
          httpResponse = [[HttpResponse alloc]init];
        if (!error) {
            // 请求成功
            if (block) {
                httpResponse.isSucess = YES;
                httpResponse.message = @"请求发送短信成功";
                block(httpResponse);
            }
        } else {
            // error
            if (block) {
                httpResponse.isSucess = NO;
                httpResponse.message = @"请求发送短信失败";
                block(httpResponse);
            }
        }
    }];
}

/**提交短信验证码*/
+(void)commitVerificationCode:(NSString *)code phoneNumber:(NSString *)phoneNumber block:(HttpResultCallBack)block{
    __block HttpResponse *httpResponse = nil;
    [SMSSDK commitVerificationCode:code phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
        if (!error) {
            // 验证成功
            httpResponse = [[HttpResponse alloc]init];
            if (block) {
                httpResponse.isSucess = YES;
                httpResponse.message = @"验证成功短信成功";
                block(httpResponse);
            }
        } else {
            // error
            if (block) {
                httpResponse.isSucess = NO;
                httpResponse.message = @"验证成功短信失败";
                block(httpResponse);;
            }
        }
    }];
}

/**登录*/
+(void)loginWithPhoneNum:(NSString *)phoneNum code:(NSString *)code block:(HttpResultCallBack)block{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:phoneNum forKey:@"phone"];
    [params setObject:code forKey:@"code"];
    NSString *uri = [HttpClient restUri:@"login"];
    [HttpClient postUri:uri params:params block:block];
}

+(void)loginCheckoutBlock:(HttpResultCallBack)block{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",[Context get].token);
    [params setObject:[Context get].token forKey:@"token"];
    NSString *uri = [HttpClient restUri:@"loginCheckout"];
    [HttpClient postUri:uri params:params block:block];
}

/**上传图片*/
+(void)postImage:(UIImage *)image name:(NSString *)fileName  progress:(UploadProgress)uploadProgress  block:(HttpResultCallBack)block {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *url = [HttpClient restUri:@"file/uploadImage"];
    
    if (imageData.length/1024 > 10) {
       imageData = UIImageJPEGRepresentation(image, 0.3
                                             );
        [HttpClient postFileData:imageData name:fileName url:url type:@"image/jpg" params:params progress:uploadProgress block:block];
    }else{
       [HttpClient postFileData:imageData name:fileName url:url type:@"image/png" params:params progress:uploadProgress block:block];
    }
 
    
}
/**上传多张图片*/
+ (void)uploadImages:(NSArray *)images names:(NSArray *)names progress:(UploadProgress)progress  block:(HttpResultCallBack)block {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[Context get].token forKey:@"token"];
    NSString *url = [HttpClient restUri:@"file/uploadImages"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __block HttpResponse *httpResponse = nil;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i ++) {
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            if (imageData.length/1024>2) {
                image  = [UIImage scaleImage:image toKb:2 * 1024];
                imageData = UIImageJPEGRepresentation(image, 1);
            }
            [formData appendPartWithFileData:imageData name:@"files" fileName:names[i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            float progressValue = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"%f",progressValue);
            progress(progressValue);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        httpResponse = [HttpResponse responseWithDict:responseObject];
        if (block) {
            block(httpResponse);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        httpResponse = [HttpResponse responseWithError:error];
        if (block) {
            httpResponse.isSucess = NO;
            httpResponse.message = @"上传文件失败";
            block(httpResponse);
        }
    }];

}

/**上传声音*/
+(void)postVoice:(NSData *)voiceData name:(NSString *)fileName time:(long)time progress:(UploadProgress)uploadProgress  block:(HttpResultCallBack)block {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(time) forKey:@"time"];
    NSString *url = [HttpClient restUri:@"file/uploadVoice"];
    [HttpClient postFileData:voiceData name:fileName url:url type:@"amr/mp3/wmr" params:params progress:uploadProgress block:block];
}

/**上传视频*/
+(void)postVideo:(NSData *)videoData name:(NSString *)fileName progress:(UploadProgress)uploadProgress  block:(HttpResultCallBack)block {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [HttpClient restUri:@"file/uploadVideo"];
    [HttpClient postFileData:videoData name:fileName url:url type:@"mp4" params:params progress:uploadProgress block:block];
}

/**上传文件*/
+(void)postFileData:(NSData *)data name:(NSString *)fileName url:(NSString *)url type:(NSString *)type params:(NSDictionary *)param progress:(UploadProgress)progress block:(HttpResultCallBack)block {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:param];
    [params setObject:[Context get].token forKey:@"token"];
    __block HttpResponse *httpResponse = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:type];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            float progressValue = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"%f",progressValue);
            progress(progressValue);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        httpResponse = [HttpResponse responseWithDict:responseObject];
        if (block) {
            block(httpResponse);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        httpResponse = [HttpResponse responseWithError:error];
        if (block) {
            httpResponse.isSucess = NO;
            httpResponse.message = @"上传文件失败";
            block(httpResponse);
        }
    }];
}

/**post请求*/
+(void)postUri:(NSString *)uri params:(NSMutableDictionary *)params block:(HttpResultCallBack)block{
    __block HttpResponse *httpResponse = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        httpResponse = [HttpResponse responseWithDict:responseObject];
        if (block) {
            block(httpResponse);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        httpResponse = [HttpResponse responseWithError:error];
        if (block) {
            httpResponse.isSucess = NO;
            httpResponse.message = @"获取数据失败";
            block(httpResponse);
        }
    }];
}

@end
