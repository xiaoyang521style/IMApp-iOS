//
//  ContactsView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ContactsView.h"
#import "ContactsTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "SCIndexViewConfiguration.h"
#import "ChatMessageTableViewController.h"
#import "BMChineseSort.h"
#import "ContactsModel.h"
#import "User.h"
@interface ContactsView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIViewController *controller;

@end
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 15.0;
@implementation ContactsView

-(instancetype)initwithContoller:(UIViewController *)controller{
    if ([super init]) {
        _controller = controller;
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{

    _resultVC = [[SearchResultController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
    _searchController.hidesNavigationBarDuringPresentation = YES;//搜索时隐藏导航栏  默认的是YES
    _searchController.searchBar.placeholder = @"搜索";
    _searchController.searchBar.showsScopeBar = YES;
    _searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH,60);
    
    for (UIView *view in [self.searchController.searchBar.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            // 重设field的frame
            field.frame = CGRectMake(15.0, 7.5, self.searchController.searchBar.frame.size.width-30.0, self.searchController.searchBar.frame.size.height-15.0);
            
            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
                _fieldW = field.frame.size.width;
                [_searchController.searchBar setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
                
            }
        }
    }
    [self addSubview:self.tableView];
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 70;
        _tableView.tableHeaderView = _searchController.searchBar;
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
        _tableView.sc_indexViewConfiguration = configuration;
        _tableView.sc_translucentForTableViewInNavigationBar = NO;
    }
    return _tableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsTableViewCell *cell =TableViewCellDequeueInit(NSStringFromClass([ContactsTableViewCell class]))
    TableViewCellDequeue(cell, [ContactsTableViewCell class], NSStringFromClass([ContactsTableViewCell class]));
    ContactsModel *sectionModel = self.dataSource[indexPath.section];
    Contacts *contact = sectionModel.items[indexPath.row];
    cell.contact = contact;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsModel *sectionModel = self.dataSource[indexPath.section];
    Contacts *contact = sectionModel.items[indexPath.row];
    User *user = [[User alloc]init];
    user.Id = contact.userId;
    user.name = contact.username;
    user.avatar = contact.icon;
    
    ChatMessageTableViewController *chatVC = [[ChatMessageTableViewController alloc]initWithUser:user roomId:contact.roomId];

    [self.controller.navigationController pushViewController:chatVC animated:YES];
}
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ContactsModel *sectionModel = self.dataSource[section];
    return sectionModel.title;
}

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSource count];
}

//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ContactsModel *sectionModel = self.dataSource[section];
    return [sectionModel.items count];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //相对父视图做约束
        make.left.and.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(StatusBarAndNavigationBarHeight);
        make.bottom.equalTo(self.mas_bottom).offset(-StatusBarHeight);
    }];
 
}
-(void)reloadData {
 
    self.indexArray = [BMChineseSort IndexWithArray:self.dataSource Key:@"username"];
    NSArray *array = [BMChineseSort sortObjectArray:self.dataSource Key:@"username"];
    
    NSMutableArray *newDataSouce = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< array.count; i++) {
        ContactsModel *model = [[ContactsModel alloc]init];
        model.title = self.indexArray[i];
        model.items = array[i];
        [newDataSouce addObject:model];
    }
    self.dataSource = newDataSouce;
    [self.tableView reloadData];

    [self.indexArray insertObject:UITableViewIndexSearch atIndex:0];
    self.tableView.sc_indexViewDataSource = self.indexArray.copy;
   
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.searchController.searchBar.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}
@end
