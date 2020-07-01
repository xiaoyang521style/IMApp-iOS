//
//  ContactsViewModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ContactsViewModel.h"

@interface ContactsViewModel()<UISearchResultsUpdating,
UISearchControllerDelegate,
UISearchBarDelegate>
@property(nonatomic, strong)ContactsView *contactsView;

@end

@implementation ContactsViewModel

-(instancetype)initWithContactsView:(ContactsView *)contactsView {
    if ([super init]) {
        _contactsView = contactsView;
        [self readDataSource];
        NotificationCenterAddObserver(self,@selector(reloadDataSource:) , NOTIFICATION_RELOADCONTACT, nil);
  
        self.contactsView.searchController.delegate = self;
        self.contactsView.searchController.searchResultsUpdater = self;
        self.contactsView.searchController.searchBar.delegate = self;
    }
    return self;
}

-(void)dealloc {
    NotificationCenterRemoveObserver(self, NOTIFICATION_RELOADCONTACT, nil);
}

-(void)reloadDataSource:(NSNotification *)notification{
    NSMutableArray *dataSource =  notification.userInfo[@"contact"];
    self.contactsView.dataSource = dataSource;
    [self.contactsView reloadData];
}

-(void)readDataSource {
    NSMutableArray *dataSource = [[MessageBus get] readContacts];
    self.contactsView.dataSource = dataSource;
    [self.contactsView reloadData];
}
// FIXME: ---------
#pragma mark UISearchResultsUpdating
// 每次更新搜索框里的文字，就会调用这个方法
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
// 根据输入的关键词及时响应：里面可以实现筛选逻辑  也显示可以联想词
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
    
}

// TODO: UISearchControllerDelegate
// These methods are called when automatic presentation or dismissal occurs.
// They will not be called if you present or dismiss the search controller yourself.
- (void)willPresentSearchController:(UISearchController *)searchController {
    if (@available(iOS 11.0, *)) {
        [UIView animateWithDuration:0.2 animations:^{
            [searchController.searchBar setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
        }];
     
    }
    NSLog(@"%s",__func__);
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
    if (@available(iOS 11.0, *)) {
        [UIView animateWithDuration:0.2 animations:^{
             [searchController.searchBar setPositionAdjustment:UIOffsetMake((self.contactsView.fieldW-self.contactsView.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
        }];
    }
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
  
}

// Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
}

#pragma mark UISearchBarDelegate

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
  
    return YES;
}

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
}

// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
 
    return YES;
}

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);

    NSLog(@"searchBar.text = %@",searchBar.text);
}

// called before text changes
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
    return YES;
}

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
}


// called when keyboard search button pressed 键盘搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
    
}

// called when bookmark button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}

// called when search results button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}

// selecte ScopeButton
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"%s",__func__);
    NSLog(@"selectedScope = %ld",selectedScope);
}

@end
