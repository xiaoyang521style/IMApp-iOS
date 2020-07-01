//
//  FindContactsController.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/5.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "FindContactsController.h"
#import "FindContactsCell.h"
#import "DAOSearchBar.h"
#import "SocketClient.h"
static CGFloat closeHeight = 181;
static CGFloat openHeight = 496;
@interface FindContactsController ()<INSSearchBarDelegate,UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)INSSearchBar *searchBar;
@property(nonatomic, strong)UILabel *titleLa;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, copy) NSMutableArray * itemHeight;
@end

@implementation FindContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.000 green:0.418 blue:0.673 alpha:1.000];
    
    self.searchBar = [[INSSearchBar alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 60, StatusBarHeight + 5,  40.0, 34.0)];
    self.searchBar.delegate = self;
    self.searchBar.searchField.placeholder = @"请输入手机号";
    [self.view addSubview:self.searchBar];
    self.titleLa = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2  - 70, StatusBarHeight + 2, 140, 40)];
    self.titleLa.textColor = [UIColor whiteColor];
    self.titleLa.font = [UIFont boldSystemFontOfSize:18];
    self.titleLa.textAlignment = NSTextAlignmentCenter;
    self.titleLa.text = @"添加好友";
    [self.view addSubview:self.titleLa];
    
    UIImage *image = [UIImage imageWithFont:ic_arrow_left  size:27 color:[UIColor whiteColor]];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 5 , 35, 35)];
    [btn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
    NotificationCenterAddObserver(self, @selector(searchContactsResult:), NOTIFICATION_SearchFriendsResult, nil);
}
-(void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc {
    NotificationCenterRemoveObserver(self, NOTIFICATION_SearchFriendsResult, nil);
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar {
    return CGRectMake(20.0, CGRectGetMaxY(self.titleLa.frame) + 10, self.view.bounds.size.width - 40.0, 34.0);
}
-(void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState {
    
}
-(void)searchBarDidTapReturn:(INSSearchBar *)searchBar {
    [[SocketClient get]searchFriends:[Context get].userId phoneNum:searchBar.searchField.text];
}

-(void)searchBarTextDidChange:(INSSearchBar *)searchBar {
    
}

-(void)searchContactsResult:(NSNotification *)notif{
    [self.dataSource removeAllObjects];
    [self.itemHeight removeAllObjects];
    NSArray *array = notif.object;
    for (NSDictionary *dict in array) {
        [self.dataSource addObject:dict];
        [self.itemHeight addObject:[NSNumber numberWithFloat:closeHeight]];
    }
    [self.tableView reloadData];
}
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLa.frame) + 10 + 34 + 20 , SCREEN_WIDTH, SCREEN_HEIGHT - (CGRectGetMaxY(self.titleLa.frame) + 10 + 34 + 20)) style:UITableViewStylePlain];
        
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemHeight.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![cell isMemberOfClass:[FindContactsCell class]]){
        return;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if([self.itemHeight[indexPath.row] floatValue] == closeHeight){
        [(FindContactsCell *)cell unfold:NO animated:NO completion:nil];
    } else {
        [(FindContactsCell *)cell unfold:YES animated:NO completion:nil];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindContactsCell class])];
    if(cell == nil){
        cell = [[FindContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FindContactsCell class])];
    }
    cell.dict = self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      return [self.itemHeight[indexPath.row] floatValue];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FindContactsCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (cell.isAnimating) {
        return;
    }
    NSTimeInterval duration = 0.0;
    if([self.itemHeight[indexPath.row] floatValue] == closeHeight){
        //open cell
        self.itemHeight[indexPath.row] = [NSNumber numberWithFloat:openHeight];
        [cell unfold:YES animated:YES completion:nil];
        duration = 0.5;
    }else{
        //close cell
        self.itemHeight[indexPath.row] = [NSNumber numberWithFloat:closeHeight];
        [cell unfold:NO animated:YES completion:nil];
        duration = 0.8;
    }
    
    [UIView animateWithDuration:duration delay:0  options:0 animations:^{
        [tableView beginUpdates];
        [tableView endUpdates];
    } completion:nil];
}
-(NSMutableArray *)itemHeight{
    if(_itemHeight == nil){
        _itemHeight = [NSMutableArray array];
    }
    return _itemHeight;
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
