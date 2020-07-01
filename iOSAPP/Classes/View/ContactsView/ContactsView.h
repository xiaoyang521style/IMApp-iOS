//
//  ContactsView.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultController.h"
@interface ContactsView : UIView
@property(nonatomic, strong)SearchResultController *resultVC;
@property(nonatomic, strong)UISearchController *searchController;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic, assign) CGFloat placeholderWidth;
@property(nonatomic, assign) CGFloat fieldW;
-(instancetype)initwithContoller:(UIViewController *)controller;
-(void)reloadData;
@end
