//
//  ContactsController.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/26.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ContactsController.h"
#import "ContactsView.h"
#import "ContactsViewModel.h"
#import "YBPopupMenu.h"
#import "ScanViewController.h"
#define TITLES @[@"搜索", @"扫一扫",@"添加好友"]
#define ICONS  @[@"menu_search.png",@"menu_saoyisao.png",@"menu_addFriend.png"]
@interface ContactsController ()<YBPopupMenuDelegate>
@property(nonatomic, strong)ContactsView *contactsView;
@property(nonatomic, strong)ContactsViewModel *contactsViewModel;
@end

@implementation ContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.contactsView];
    [self.contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.contactsViewModel = [[ContactsViewModel alloc]initWithContactsView:self.contactsView];
    [self.contactsViewModel readDataSource];
    
    UIImage *image = [UIImage imageWithFont:ic_add size:23 color:[UIColor blackColor]];
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc]initWithImage:image style:0 target:self action:@selector(rigthClick:)];
    
    self.navigationItem.rightBarButtonItem = rigthBtn;
    self.definesPresentationContext = YES;
}
-(void)rigthClick:(UIButton *)sender {
    [self showCustomPopupMenuWithPoint:CGPointMake(SCREEN_WIDTH - 10 - 20, StatusBarAndNavigationBarHeight + 5)];

}
- (void)showCustomPopupMenuWithPoint:(CGPoint)point {
    [YBPopupMenu showAtPoint:point titles:TITLES icons:ICONS menuWidth:135 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.cornerRadius = 8;
        popupMenu.rectCorner = UIRectCornerAllCorners;
        popupMenu.tag = 100;
        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    
    if (index == 2) {
        [[Navigator get]showFindContacts];
    }
    
    if (index == 1) {
        [[Navigator get]showScanVC];
    }
    
}

-(ContactsView *)contactsView {
    if (_contactsView == nil) {
        _contactsView = [[ContactsView alloc]initwithContoller:self];
    }
    return _contactsView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
