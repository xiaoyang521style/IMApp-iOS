//
//  SessionViewModel.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/28.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SessionView;
@class SessionController;
@interface SessionViewModel : NSObject
-(instancetype)initView:(SessionView *)sessionView controller:(SessionController *)controller;
@end
