//
//  SideDrawerViewController.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "DrawerRootController.h"
#import "LeftDrawerHeaderView.h"
#import "MMSideDrawerTableViewCell.h"
#import "MMSideDrawerSectionHeaderView.h"
typedef NS_ENUM(NSInteger, MMDrawerSection){
    DrawerSectionViewSelection,
    DrawerSectionDrawerWidth,
    DrawerSectionShadowToggle,
    DrawerSectionOpenDrawerGestures,
    DrawerSectionCloseDrawerGestures,
    DrawerSectionCenterHiddenInteraction,
    DrawerSectionStretchDrawer,
};
@interface SideDrawerViewController : DrawerRootController
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * drawerWidths;
@property (nonatomic,strong) LeftDrawerHeaderView *headerView;
@end
