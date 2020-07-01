//
//  SessionModel.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/29.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SessionModel : NSObject
@property(nonatomic, assign)int userId;
@property(nonatomic, assign)int sendUserId;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, assign)long long timestamp;
@property(nonatomic, copy)NSString *icon;
@property(nonatomic, assign) int unReadCount;
@property(nonatomic, copy)NSString *roomId;
-(instancetype)initWith:(ChatRecord *)chatRecord;
@end
