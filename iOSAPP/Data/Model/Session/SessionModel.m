//
//  SessionModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/29.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SessionModel.h"

@implementation SessionModel
-(instancetype)initWith:(ChatRecord *)chatRecord {
    
    if ([super init]) {
        
        if (chatRecord.chatRecordType == ChatRecordTypeText) {
            _content = chatRecord.content;
        }
        
        if (chatRecord.chatRecordType == ChatRecordTypeAudio) {
            _content = @"[语音消息]";
        }
        
        if (chatRecord.chatRecordType == ChatRecordTypeImage) {
            _content = @"[图片]";
        }
        
        if (chatRecord.chatRecordType == ChatRecordTypeVideo) {
            _content = @"[视频]";
        }
        
        if (chatRecord.chatRecordType == ChatRecordTypeLocation) {
            _content = @"[位置消息]";
        }
        
        __weak typeof(self) weakself = self;
        
        [[[MessageBus get]readContacts]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Contacts *contact = obj;
            if (contact.userId == chatRecord.toUserId || contact.userId == chatRecord.fromUserId) {
                weakself.userId = contact.userId;
                weakself.username = contact.username;
                weakself.icon = contact.icon;
                weakself.roomId = contact.roomId;
                weakself.sendUserId = chatRecord.fromUserId;
            }
            
        }];
        self.timestamp = chatRecord.timestamp;
    }
    
    return self;
    
}

@end
