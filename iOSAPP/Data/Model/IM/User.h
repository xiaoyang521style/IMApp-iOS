//
//  User.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "JSONModel.h"

@interface User : JSONModel
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@end
