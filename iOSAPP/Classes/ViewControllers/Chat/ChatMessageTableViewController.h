//
//  ChatMessageTableViewController.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import "ChatMessageViewModel.h"

@interface ChatMessageTableViewController : XHMessageTableViewController
- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId;

@end
