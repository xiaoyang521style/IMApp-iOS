//
//  DAOSearchBar.h
//  DAOSearchBar
//
//  Created by xiaoyang on 2018/6/5.
//  Copyright © 2018年 xiaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class INSSearchBar;
typedef NS_ENUM(NSInteger, INSSearchBarState) {
    Normal,//默认从0开始
    SearchBarVisible,
    SearchBarHasContent,
    Transitioning
};

@protocol INSSearchBarDelegate<NSObject>
-(CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar;
-(void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState;
-(void)searchBarDidTapReturn:(INSSearchBar *)searchBar;
-(void)searchBarTextDidChange:(INSSearchBar *)searchBar;
@end

@interface INSSearchBar:UIView
@property(nonatomic, assign)INSSearchBarState state;
@property(nonatomic, weak)id<INSSearchBarDelegate>delegate;
@property(nonatomic, strong)UIView *searchFrame;
@property(nonatomic, strong)UITextField *searchField;
@property(nonatomic, strong)UIImageView *searchImageViewOff;
@property(nonatomic, strong)UIImageView *searchImageViewOn;
@property(nonatomic, strong)UIImageView *searchImageCrossLeft;
@property(nonatomic, strong)UIImageView *searchImageCrossRight;
@property(nonatomic, strong)UIImageView *searchImageCircle;
@property(nonatomic, strong)UIColor *searchOffColor;
@property(nonatomic, strong)UIColor *searchOnColor;
@property(nonatomic, strong)UIColor *searchBarOffColor;
@property(nonatomic, strong)UIColor *searchBarOnColor;
@property(nonatomic, strong)UITapGestureRecognizer *keyboardDismissGestureRecognizer;
@property(nonatomic, assign)CGRect originalFrame;
@end
