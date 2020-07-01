//
//  Contact.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/30.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "JSONModel.h"

@interface Contact : JSONModel
@property (nonatomic, copy) NSNumber *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@end
