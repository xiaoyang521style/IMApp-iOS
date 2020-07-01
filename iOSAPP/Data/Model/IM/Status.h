//
//  Status.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "JSONModel.h"

@interface Status : JSONModel
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) NSNumber *likeNum;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSNumber *imageScale;
@property (nonatomic, assign) BOOL youLike;
@end
