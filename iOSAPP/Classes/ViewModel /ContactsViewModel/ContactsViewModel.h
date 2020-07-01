//
//  ContactsViewModel.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsView.h"
@interface ContactsViewModel : NSObject
-(instancetype)initWithContactsView:(ContactsView *)contactsView;
-(void)readDataSource;
@end
