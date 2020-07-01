//
//  ChatMessageViewModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatMessageViewModel.h"
#import "User.h"
#import "VoiceHelper.h"
#import "DeviceInfo.h"
#import "Util.h"
@interface ChatMessageViewModel ()
@property (nonatomic, strong, readwrite) User *user;
@property (nonatomic, copy) NSString *roomId;
@end

@implementation ChatMessageViewModel

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
            XHMessage *message = [self handelChatRecord:chatRecord];
            [self.messages addObject:message];
        }
    }
    return self;
}

-(XHMessage *)handelChatRecord:(ChatRecord *)chatRecord {
    XHMessage *message;
     NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:chatRecord.sentTime/1000];
    switch (chatRecord.chatRecordType) {
        case ChatRecordTypeText:{
            XHMessage *textMessage;
            if (self.user.Id == chatRecord.fromUserId) {
                textMessage = [[XHMessage alloc]initWithText:chatRecord.content sender:self.user.name  timestamp:dateTime];
                textMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                textMessage.avatarUrl = self.user.avatar;
            }else{
                textMessage = [[XHMessage alloc]initWithText:chatRecord.content sender:@"" timestamp:dateTime];
                textMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                textMessage.avatarUrl = [Context get].icon;
            }
            message = textMessage;
        }
        break;
        case ChatRecordTypeImage:{
            XHMessage *photoMessage;
            NSDictionary *dict = [JSON parse:chatRecord.content];
            NSString *thumbImageURI = dict[@"thumbUri"];
            NSString *imageURI = dict[@"imageUri"];
             if (self.user.Id == chatRecord.fromUserId) {
                 photoMessage = [[XHMessage alloc]initWithPhoto:nil originPhotoPath:nil thumbnailUrl:thumbImageURI originPhotoUrl:imageURI sender:self.user.name timestamp:dateTime];
                 photoMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                 photoMessage.avatarUrl = self.user.avatar;
            } else {
                NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *dataFilePath = [docsdir stringByAppendingPathComponent:thumbImageURI];
                UIImage *image = [UIImage imageWithContentsOfFile:dataFilePath];
                photoMessage = [[XHMessage alloc]initWithPhoto:image originPhotoPath:imageURI thumbnailUrl:nil originPhotoUrl:nil sender:@"" timestamp:dateTime];
                photoMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                photoMessage.avatarUrl = [Context get].icon;
            }
             message = photoMessage;
        }
        break;
            
        case ChatRecordTypeLocation:{
            
        }
        break;
            
        case ChatRecordTypeVideo:{
            NSDictionary *dict = [JSON parse:chatRecord.content];
            NSString *imageuri = dict[@"imageuri"];
            NSString *videouri = dict[@"videouri"];
             XHMessage *videoMessage;
            if (self.user.Id == chatRecord.fromUserId) {
                videoMessage = [[XHMessage alloc]initWithVideoConverPhoto:nil videoPath:imageuri videoUrl:videouri sender:self.user.name timestamp:dateTime];
                videoMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                videoMessage.avatarUrl = self.user.avatar;
            }else{
                NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *imagePath = [docsdir stringByAppendingPathComponent:imageuri];
                
                NSString *videoPath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",videouri]];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                videoMessage = [[XHMessage alloc]initWithVideoConverPhoto:image videoPath:videoPath videoUrl:nil sender:@"" timestamp:dateTime];
                videoMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                videoMessage.avatarUrl = [Context get].icon;
            }
            message = videoMessage;
        }
        break;
        case ChatRecordTypeAudio:{
            NSDictionary *dict = [JSON parse:chatRecord.content];
            NSString *duration = [NSString stringWithFormat:@"%@",dict[@"duration"]];
            NSString *audioUri = dict[@"audioUri"];
            XHMessage *voiceMessage;
            if (self.user.Id == chatRecord.fromUserId) {
                voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:audioUri voiceDuration:duration sender:self.user.name timestamp:[NSDate date] isRead:NO];
                voiceMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                voiceMessage.avatarUrl = [Context get].icon;
                if (chatRecord.state == 1) {
                    voiceMessage.isRead = YES;
                }else{
                    voiceMessage.isRead = NO;
                }
            }else{
                NSString *docomentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                
                NSString *path = [docomentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",audioUri]];
                
                voiceMessage = [[XHMessage alloc] initWithVoicePath:path voiceUrl:nil voiceDuration:duration sender:@"" timestamp:[NSDate date] isRead:YES];
                voiceMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                voiceMessage.avatarUrl = [Context get].icon;
            }
            message = voiceMessage;
        }
            break;
        default:
            break;
    }
    return message;
}



/**
 发送文案
 */
- (void)sendText:(NSString *)textStr date:(NSDate *)date block:(Response)block {
    
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    ChatRecord *chatRecord = [ChatRecord new];
    chatRecord.chatRecordType = ChatRecordTypeText;
    chatRecord.fromUserId = (int)[Context get].userId;
    chatRecord.toUserId = (int)self.user.Id;
    chatRecord.content = textStr;
    chatRecord.sentTime = time;
    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];
    
    __weak typeof(self) weakSelf = self;
    [[MessageBus get] sendChatRecord:chatRecord roomId:_roomId sendComplete:^(BOOL success) {
      
    }];
    
    [[MessageBus get].chatRecords addObject:chatRecord];
    XHMessage *message = [self handelChatRecord:chatRecord];
    [Util dispatchMainAsync:^{
        [[RealmTable get]writeChatRecord:chatRecord];
        NSDictionary *chatRecordDict = @{@"needUpateReadCount":@NO,@"chatRecord":chatRecord};
        NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
        NotificationCenterPost(NOTIFICATION_NEWMESSAGE, chatRecord, nil);
    }];
    
    if (block) {
        block(YES,message);
    }
}


/**
 发送图片
 */
-(void)sendThumbImage:(UIImage *)thumbImage  previewImage:(UIImage *)previewImage asset:(PHAsset *)asset date:(NSDate *)date block:(Response)block {
    
    NSString *imageID = [DeviceInfo getDeviceId];
    NSString *filename = [asset valueForKey:@"filename"];

    NSString * thumbFilename = [NSString stringWithFormat:@"%@-thumb-%@",imageID,filename];
    NSString * previewFilename = [NSString stringWithFormat:@"%@-preview-%@",imageID,filename];
    
    NSTimeInterval time=[date timeIntervalSince1970]*1000;

    NSMutableArray *images = [NSMutableArray new];
    [images addObject:thumbImage];
    [images addObject:previewImage];
    NSMutableArray *names = [NSMutableArray new];
    [names addObject:thumbFilename];
    [names addObject:previewFilename];
    
    [HttpClient uploadImages:images names:names progress:^(float uploadProgress) {
        
    } block:^(HttpResponse *response) {
         if (response.isSucess) {
             NSArray *imagesResult = response.result;
             NSString *thumbUri;
             NSString *imageUri;
             for (NSDictionary *result in imagesResult) {
                 NSString *type = result[@"type"];
                 if ([type isEqualToString:@"thumb"]) {
                    thumbUri = result[@"path"];
                 }
                 if ([type isEqualToString:@"preview"]) {
                    imageUri = result[@"path"];
                 }
             }
            NSDictionary *contentDict = @{@"thumbUri":thumbUri,@"imageUri":imageUri};
             
            [[SocketClient get]sendImageToUser:(int)[Context get].userId content:[JSON toString:contentDict] timestamp:time friendId:(int)self.user.Id roomId:@"" sendComplete:^(BOOL success) {
             
                         }];
         }
    }];

    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 1);
    NSString *thumbUrl = [self saveToDir:thumbFilename data:thumbImageData fileName:@"image"];
    
    
    NSData *previewImageData = UIImageJPEGRepresentation(previewImage, 1);
    NSString *previewUrl = [self saveToDir:previewFilename data:previewImageData fileName:@"image"];
    
    NSDictionary *contentDict = @{@"thumbUri":thumbUrl,@"imageUri":previewUrl};
    ChatRecord *chatRecord = [ChatRecord new];
    chatRecord.chatRecordType = ChatRecordTypeImage;
    chatRecord.fromUserId = (int)[Context get].userId;
    chatRecord.toUserId = (int)self.user.Id;
    chatRecord.content = [JSON toString:contentDict];
    chatRecord.sentTime = time;
    chatRecord.primaryKey = [NSString stringWithFormat:@"%d-%lld",chatRecord.fromUserId,chatRecord.sentTime];

    [[MessageBus get].chatRecords addObject:chatRecord];
    XHMessage *message = [self handelChatRecord:chatRecord];

     [Util dispatchMainAsync:^{
        [[RealmTable get]writeChatRecord:chatRecord];
         NSDictionary *chatRecordDict = @{@"needUpateReadCount":@true,@"chatRecord":chatRecord};
         NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
         NotificationCenterPost(NOTIFICATION_NEWMESSAGE, chatRecord, nil);
     }];

    if (block) {
        block(YES,message);
    }

    
}

/**发送视频*/
-(void)sendVideo:(NSData *)videoData image:(UIImage*)image date:(NSDate *)date asset:(PHAsset *)asset block:(Response)block {
    
    NSString *imageID = [DeviceInfo getDeviceId];
    NSString *filename = [asset valueForKey:@"filename"];
    NSArray *arr = [filename componentsSeparatedByString:@"."];
    
    NSString *videoname = [NSString stringWithFormat:@"%@-%@.mp4",imageID,arr[0]];
    
    NSString *imagename = [NSString stringWithFormat:@"%@-%@.png",imageID,arr[0]];
    
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
     XHMessage *message = [self handelChatRecord:chatRecord];
     [[MessageBus get].chatRecords addObject:chatRecord];
    if (block) {
        block(YES,message);
    }
}

/**发送音频*/
-(void)sendVoicePath:(NSString *)path date:(NSDate *)date duration:(long)duration block:(Response)block {
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString * filename = [NSString stringWithFormat:@"%ld-%ld.m4a",[Context get].userId,(long)time];
   
    NSData *m4aData = [NSData dataWithContentsOfFile:path];
    NSString *m4aPath = [self saveToDir:filename data:m4aData fileName:@"voice"];
    [HttpClient postVoice:m4aData name:filename time:duration progress:^(float uploadProgress) {
        
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
    NSDictionary *contentDict = @{@"audioUri":m4aPath,@"duration":@(duration)};
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
    
    XHMessage *message = [self handelChatRecord:chatRecord];
    [[MessageBus get].chatRecords addObject:chatRecord];
    if (block) {
        block(YES,message);
    }
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
/**发送音频*/
-(void)sendVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration block:(Response)block {
    
}

-(void)dealloc {
    
}

@end
