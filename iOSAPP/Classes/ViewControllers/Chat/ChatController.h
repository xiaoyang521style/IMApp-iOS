//
//  ChatViewController.h
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "BaseViewController.h"

@class User;

@interface ChatController : BaseViewController

- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId;

@end
