//
//  ChatViewModel.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatViewModel.h"
#import "User.h"
#import "Message.h"
#import "TextMessage.h"
#import "ImageMessage.h"
#import "LocationMessage.h"
#import "VoiceMessage.h"
#import "JSON.h"
#import "DeviceInfo.h"
#import "VoiceHelper.h"
#import "VideoMessage.h"
#import "Util.h"
@interface ChatViewModel ()
@property (nonatomic, strong, readwrite) User *user;
@property (nonatomic, copy) NSString *roomId;
@end

@implementation ChatViewModel

-(NSMutableArray *)messages {
    if (_messages == nil) {
        _messages = [NSMutableArray new];
    }
    return _messages;
}
- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId {
    if (self = [super init]) {
        _user = user;
        _roomId = roomId;
       NSArray *chatRecords = [[MessageBus get] readChatRecordHistory:user.Id];
        for (ChatRecord *chatRecord in chatRecords) {
            Message *message = [self handelChatRecord:chatRecord];
            [self.messages addObject:message];
        }
    }
    return self;
}

-(Message *)handelChatRecord:(ChatRecord *)chatRecord {
    MessageContent *content;
    switch (chatRecord.chatRecordType) {
        case ChatRecordTypeText:{
            content = [TextMessage messageWithContent:chatRecord.content];
        }
            break;
        case ChatRecordTypeImage:{
            NSDictionary *dict = [JSON parse:chatRecord.content];
            NSString *thumbImageURI = dict[@"thumbUri"];
            NSString *imageURI = dict[@"imageUri"];
            content = [ImageMessage messageWithImageURI:imageURI thumbImageURI:thumbImageURI];
        }
            break;
            
        case ChatRecordTypeLocation:{
            NSDictionary *dict = [JSON parse:chatRecord.content];
            CLLocationCoordinate2D location;
            location.latitude = [dict[@"lat"]doubleValue];
            location.longitude = [dict[@"lon"]doubleValue];
            NSString *locationName = dict[@"name"];
            content = [LocationMessage messageWithLocationImage:nil location:location locationName:locationName];
        }
            break;
            
        case ChatRecordTypeVideo:{
            NSDictionary *dict = [JSON parse:chatRecord.content];
            NSString *imageuri = dict[@"imageuri"];
            NSString *videouri = dict[@"videouri"];
            content = [VideoMessage messageWithVideoURI:videouri imageURI:imageuri];
        }
            break;
        case ChatRecordTypeAudio:{
            NSDictionary *dict = [JSON parse:chatRecord.content];
            long duration = [dict[@"duration"]doubleValue];
            NSString *audioUri = dict[@"audioUri"];
            content = [VoiceMessage messageWithAudioURi:audioUri duration:duration];
        }
            break;
        default:
            break;
    }
    Message *message;
    if (chatRecord.fromUserId == self.user.Id) {
        message = [[Message alloc]initWithTargetId:chatRecord.toUserId direction:MessageDirection_RECEIVE messageId:0 content:content];
    }else{
        message = [[Message alloc]initWithTargetId:chatRecord.toUserId direction:MessageDirection_SEND messageId:0 content:content];
    }
    message.senderUserId = chatRecord.fromUserId;
    message.type = chatRecord.chatRecordType;
    message.sentTime = chatRecord.sentTime;
    return message;
}

/**
 发送文案
 */
- (void)sendText:(NSString *)textStr block:(Response)block {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    ChatRecord *chatRecord = [ChatRecord new];
    chatRecord.chatRecordType = ChatRecordTypeText;
    chatRecord.fromUserId = (int)[Context get].userId;
    chatRecord.toUserId = (int)self.user.Id;
    chatRecord.content = textStr;
    chatRecord.sentTime = time;
    __weak typeof(self) weakSelf = self;
    [[MessageBus get] sendChatRecord:chatRecord roomId:_roomId sendComplete:^(BOOL success) {
        Message *message = [weakSelf handelChatRecord:chatRecord];
        [weakSelf.messages addObject:message];
        if (block) {
            block(YES,message);
        }
    }];
}

/**
 发送图片
 */
-(void)sendImage:(UIImage *)image asset:(PHAsset *)asset block:(Response)block {
    
    NSString *imageID = [DeviceInfo getDeviceId];
    NSString *filename = [asset valueForKey:@"filename"];
    filename = [NSString stringWithFormat:@"%@-%@",imageID,filename];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    
    [HttpClient postImage:image name:filename progress:^(float uploadProgress) {
        
    } block:^(HttpResponse *response) {
        if (response.isSucess) {
            NSDictionary *result = response.result;
            NSString *path = result[@"path"];
            NSDictionary *contentDict = @{@"thumbUri":path,@"imageUri":path};
            [[SocketClient get]sendImageToUser:(int)[Context get].userId content:[JSON toString:contentDict] timestamp:time friendId:(int)self.user.Id roomId:@"" sendComplete:^(BOOL success) {
                
            }];
        }
    }];
    
    NSData *newImageData = UIImageJPEGRepresentation(image, 1);
    NSString *url = [self saveToDir:filename data:newImageData fileName:@"image"];
    NSDictionary *contentDict = @{@"thumbUri":url,@"imageUri":url};
    ChatRecord *chatRecord = [ChatRecord new];
    chatRecord.chatRecordType = ChatRecordTypeImage;
    chatRecord.fromUserId = (int)[Context get].userId;
    chatRecord.toUserId = (int)self.user.Id;
    chatRecord.content = [JSON toString:contentDict];
    chatRecord.sentTime = time;

    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
    
    [[RealmTable get]writeChatRecord:chatRecord];
    NSDictionary *chatRecordDict = @{@"needUpateReadCount":@true,@"chatRecord":chatRecord};
    NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
    NotificationCenterPost(NOTIFICATION_NEWMESSAGE, chatRecord, nil);
}



/**发送音频*/
-(void)sendVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration block:(Response)block {
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString * filename = [NSString stringWithFormat:@"%ld-%ld.amr",[Context get].userId,(long)time];
    //wav转amr
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(
                                                           NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *amrPath = [docPath stringByAppendingPathComponent:filename];
    [VoiceHelper wavToAmr:path amrSavePath:amrPath];
    NSData *amrData = [NSData dataWithContentsOfFile:amrPath];
    [HttpClient postVoice:amrData name:filename time:duration progress:^(float uploadProgress) {
    
    } block:^(HttpResponse *response) {
        if (response.isSucess) {
            NSDictionary *result = response.result;
            NSString *url = result[@"url"];
            double time = [result[@"time"] doubleValue];
            NSDictionary *contentDict = @{@"audioUri":url,@"duration":@(time)};
            [[SocketClient get]sendAudioToUser:(int)[Context get].userId content:[JSON toString:contentDict] timestamp:time friendId:(int)self.user.Id roomId:_roomId sendComplete:^(BOOL success) {
                
            }];
        }
    }];
    NSDictionary *contentDict = @{@"audioUri":filename,@"duration":@(duration)};
    ChatRecord *chatRecord = [ChatRecord new];
    chatRecord.chatRecordType = ChatRecordTypeAudio;
    chatRecord.fromUserId = (int)[Context get].userId;
    chatRecord.toUserId = (int)self.user.Id;
    chatRecord.content = [JSON toString:contentDict];
    chatRecord.sentTime = time;
    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
    [[RealmTable get]writeChatRecord:chatRecord];
    NSDictionary *chatRecordDict = @{@"needUpateReadCount":@true,@"chatRecord":chatRecord};
    NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
    NotificationCenterPost(NOTIFICATION_NEWMESSAGE, chatRecord, nil);
}

/**发送视频*/
-(void)sendVideo:(NSData *)videoData image:(UIImage*)image  asset:(PHAsset *)asset block:(Response)block {
    NSString *imageID = [DeviceInfo getDeviceId];
    NSString *filename = [asset valueForKey:@"filename"];
    
    NSArray *arr = [filename componentsSeparatedByString:@"."];
    
    NSString *videoname = [NSString stringWithFormat:@"%@-%@.mp4",imageID,arr[0]];
    
    NSString *imagename = [NSString stringWithFormat:@"%@-%@.png",imageID,arr[0]];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    
    [HttpClient postVideo:videoData name:videoname  progress:^(float uploadProgress) {
        
    } block:^(HttpResponse *response) {
        if (response.isSucess) {
            NSDictionary *dict = response.result;
            NSString *imageUrl = dict[@"imageurl"];
            NSString *videoUrl = dict[@"url"];
            NSDictionary *contentDict = @{@"imageuri":imageUrl, @"videouri":videoUrl};
            
            [[SocketClient get]sendVideoToUser:(int)[Context get].userId content:[JSON toString:contentDict] timestamp:time friendId:(int)self.user.Id roomId:_roomId sendComplete:^(BOOL success) {
                
            }];
        }
    }];
    
    //存缩略图
    NSData *newImageData = UIImageJPEGRepresentation(image, 1);
    NSString *imageurl = [self saveToDir:imagename data:newImageData fileName:@"image"];
    
    //存视频
    NSString *videourl = [self saveToDir:videoname data:videoData fileName:@"video"];
    
    NSDictionary *contentDict = @{@"imageuri":imageurl, @"videouri":videourl};
    ChatRecord *chatRecord = [ChatRecord new];
    chatRecord.chatRecordType = ChatRecordTypeVideo;
    chatRecord.fromUserId = (int)[Context get].userId;
    chatRecord.toUserId = (int)self.user.Id;
    chatRecord.content = [JSON toString:contentDict];
    chatRecord.sentTime = time;
    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
    
    [Util dispatchMainAsync:^{
        
        [[RealmTable get]writeChatRecord:chatRecord];
        NSDictionary *chatRecordDict = @{@"needUpateReadCount":@true,@"chatRecord":chatRecord};
        NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
        NotificationCenterPost(NOTIFICATION_NEWMESSAGE, chatRecord, nil);
    }];

}

- (NSString *)saveToDir:(NSString *)imageName data:(NSData *)data fileName:(NSString *)fileName {
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:fileName]; // 在Document目录下创建 "fileName" 文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir && existed)) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [dataFilePath stringByAppendingPathComponent:imageName];
    [data writeToFile:filePath atomically:YES];
    return [NSString stringWithFormat:@"%@/%@",fileName,imageName];
}

@end
