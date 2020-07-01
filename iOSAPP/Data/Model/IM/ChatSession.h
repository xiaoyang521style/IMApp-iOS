//
//  ChatSession.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "JSONModel.h"

@interface ChatSession : JSONModel
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *sessionName;
@property (nonatomic, copy) NSString *lastSentence;
@property (nonatomic, copy) NSString *time;
- (BOOL)isEqualToSession:(ChatSession *)session;
@end
