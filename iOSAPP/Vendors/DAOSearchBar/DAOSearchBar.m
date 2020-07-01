//
//  DAOSearchBar.m
//  DAOSearchBar
//
//  Created by xiaoyang on 2018/6/5.
//  Copyright © 2018年 xiaoyang. All rights reserved.
//

#import "DAOSearchBar.h"

CGFloat kINSSearchBarInset = 11.0;
CGFloat kINSSearchBarImageSize = 22.0;
NSTimeInterval  kINSSearchBarAnimationStepDuration = 0.25;

@interface INSSearchBar()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@end

@implementation INSSearchBar

-(instancetype)initWithFrame:(CGRect)frame {
  
    
    if ([super initWithFrame:frame]) {
        
        self.searchOffColor = [UIColor whiteColor];
        self.searchOnColor = [UIColor blackColor];
        self.searchBarOffColor = [UIColor clearColor];
        self.searchBarOnColor = [UIColor whiteColor];
        
        self.searchFrame = [[UIView alloc]initWithFrame:CGRectZero];
        self.searchField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.searchImageViewOff = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.searchImageViewOn = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.searchImageCircle = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.searchImageCrossLeft = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.searchImageCrossRight = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.keyboardDismissGestureRecognizer = [[UITapGestureRecognizer alloc]init];
        self.originalFrame = CGRectZero;
        
        self.opaque = false;
        self.backgroundColor = [UIColor clearColor];
        self.searchFrame.frame = self.bounds;
        self.searchFrame.opaque = false;
        self.searchFrame.backgroundColor = [UIColor clearColor];
        self.searchFrame.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
        self.searchFrame.layer.masksToBounds = true;
        self.searchFrame.layer.cornerRadius = self.bounds.size.height / 2;
        self.searchFrame.layer.borderWidth = 1.0;
        self.searchFrame.layer.borderColor = [UIColor clearColor].CGColor;
        self.searchFrame.contentMode = UIViewContentModeRedraw;
        [self addSubview:self.searchFrame];
        
        self.searchField.frame = CGRectMake(kINSSearchBarInset, 3.0, self.bounds.size.width - (2 * kINSSearchBarInset) - kINSSearchBarImageSize, self.bounds.size.height - 6.0);
        self.searchField.borderStyle = UITextBorderStyleNone;
        self.searchField.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
        self.searchField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
        self.searchField.textColor = self.searchOnColor;
        self.searchField.alpha = 0.0;
        self.searchField.delegate = self;
        [self.searchFrame addSubview:self.searchField];
        
        UIView *searchImageViewOnContainerView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width - kINSSearchBarInset - kINSSearchBarImageSize, (self.bounds.size.height - kINSSearchBarImageSize) / 2, kINSSearchBarImageSize, kINSSearchBarImageSize)];
        searchImageViewOnContainerView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.searchFrame addSubview:searchImageViewOnContainerView];
        self.searchImageViewOn.frame = searchImageViewOnContainerView.bounds;
        self.searchImageViewOn.alpha = 0.0;
        self.searchImageViewOn.image = [UIImage imageNamed:@"NavBarIconSearch"];
        self.searchImageViewOn.tintColor = self.searchOnColor;
        [searchImageViewOnContainerView addSubview:self.searchImageViewOn];
        
        self.searchImageCircle.frame = CGRectMake(0.0, 0.0, 18.0, 18.0);
        self.searchImageCircle.alpha = 0.0;
        self.searchImageCircle.image = [[UIImage imageNamed:@"NavBarIconSearchCircle"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.searchImageCircle.tintColor = self.searchOnColor;
        [searchImageViewOnContainerView addSubview:self.searchImageCircle];
        
        self.searchImageCrossLeft.frame = CGRectMake( 14.0, 14.0, 8.0, 8.0);
        self.searchImageCrossLeft.alpha = 0.0;
        self.searchImageCrossLeft.image = [[UIImage imageNamed:@"NavBarIconSearchBar"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.searchImageCrossLeft.tintColor = self.searchOnColor;
        [searchImageViewOnContainerView addSubview:self.searchImageCrossLeft];
        
        
        self.searchImageCrossRight.frame = CGRectMake( 7.0, 7.0, 8.0, 8.0);
        self.searchImageCrossRight.alpha = 0.0;
        self.searchImageCrossRight.image = [[UIImage imageNamed:@"NavBarIconSearchBar2"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.searchImageCrossRight.tintColor = self.searchOnColor;
        [searchImageViewOnContainerView addSubview:self.searchImageCrossRight];
        
        self.searchImageViewOff.frame = CGRectMake(self.bounds.size.width - kINSSearchBarInset - kINSSearchBarImageSize, (self.bounds.size.height - kINSSearchBarImageSize) / 2,kINSSearchBarImageSize, kINSSearchBarImageSize);
         self.searchImageViewOff.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.searchImageViewOff.alpha = 1.0;
        self.searchImageViewOff.image = [[UIImage imageNamed:@"NavBarIconSearch"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.searchImageViewOff.tintColor = self.searchOffColor;
        [self.searchFrame addSubview:self.searchImageViewOff];
        
        
        UIView *tapableView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width - (2 * kINSSearchBarInset) - kINSSearchBarImageSize, 0.0, (2 * kINSSearchBarInset) + kINSSearchBarImageSize, self.bounds.size.height)];
        tapableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleHeight;
        [tapableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeStateIfPossible:)]];
        [self.searchFrame addSubview:tapableView];
        
        
        [self.keyboardDismissGestureRecognizer addTarget:self action:@selector(dismissKeyboard:)];
        self.keyboardDismissGestureRecognizer.cancelsTouchesInView = false;
        self.keyboardDismissGestureRecognizer.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textDidChange:(NSNotification *)notif {
    BOOL hasText = self.searchField.text.length;
    if (hasText){
        if (self.state == SearchBarVisible) {
            self.state = Transitioning;
            self.searchImageViewOn.alpha = 0.0;
            self.searchImageCircle.alpha = 1.0;
            self.searchImageCrossLeft.alpha = 1.0;
            [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
                self.searchImageCircle.frame = CGRectMake( 2.0, 2.0, 18.0, 18.0);
                self.searchImageCrossLeft.frame = CGRectMake( 7.0, 7.0, 8.0, 8.0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
                    self.searchImageCrossRight.alpha = 1.0;
                } completion:^(BOOL finished) {
                    self.state = SearchBarHasContent;
                }];
            }];
        }
    }else{
        if (self.state == SearchBarHasContent) {
            self.state = Transitioning;
            [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
                self.searchImageCrossRight.alpha = 0.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
                    self.searchImageCircle.frame = CGRectMake( 0.0, 0.0, 18.0, 18.0);
                    self.searchImageCrossLeft.frame = CGRectMake( 14.0, 14.0, 8.0, 8.0);
                } completion:^(BOOL finished) {
                    self.searchImageViewOn.alpha = 1.0;
                    self.searchImageCircle.alpha = 0.0;
                    self.searchImageCrossLeft.alpha = 0.0;
                    self.state = SearchBarVisible;
                }];
            }];
        }
    }
    
    if (self.delegate){
        [self.delegate searchBarTextDidChange:self];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL retVal = true;
    
    if (self.delegate) {
        [self.delegate searchBarDidTapReturn:self];
    }
    return retVal;
}

-(void)keyboardWillShow:(NSNotification *)notif {
    if (self.searchField.isFirstResponder) {
         UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController.view addGestureRecognizer:self.keyboardDismissGestureRecognizer];
    }
}
-(void)keyboardWillHide:(NSNotification *)notif {
    if (self.searchField.isFirstResponder) {
       UIWindow * window = [UIApplication sharedApplication].keyWindow; [window.rootViewController.view addGestureRecognizer:self.keyboardDismissGestureRecognizer];
    }
}
-(void)dismissKeyboard:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.searchField.isFirstResponder) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window endEditing:YES];
        if (self.state == SearchBarVisible && self.searchField.text.length == 0) {
            [self hideSearchBar:nil];
        }
    }
}
-(void)changeStateIfPossible:(UITapGestureRecognizer *)gestureRecognizer {
    switch (self.state) {
        case Normal:
             [self showSearchBar:gestureRecognizer];
            break;
        case SearchBarVisible:
            [self hideSearchBar:gestureRecognizer];
            break;
        case SearchBarHasContent:
            self.searchField.text = nil;
            [self textDidChange:nil];
            break;
        default:
            break;
    }
}

-(void)showSearchBar:(id)sender {
    if (self.state == Normal) {
        if (self.delegate) {
            [self.delegate searchBar:self didEndTransitioningFromState:SearchBarVisible];
        }
        self.state = Transitioning;
        self.searchField.text = nil;
        [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
            self.searchFrame.layer.borderColor = [UIColor whiteColor].CGColor;
            if (self.delegate) {
                self.originalFrame = self.frame;
                self.frame = [self.delegate destinationFrameForSearchBar:self];
            }
        } completion:^(BOOL finished) {
            [self.searchField becomeFirstResponder];
            [UIView animateWithDuration:kINSSearchBarAnimationStepDuration * 2 animations:^{
                self.searchFrame.layer.backgroundColor = self.searchBarOnColor.CGColor;
                self.searchImageViewOff.alpha = 0.0;
                self.searchImageViewOn.alpha = 1.0;
                self.searchField.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.state = SearchBarVisible;
                if (self.delegate) {
                    [self.delegate searchBar:self didEndTransitioningFromState:Normal];
                }
            }];
        }];
    }
}

-(void)hideSearchBar:(id)sender {
    if (self.state == SearchBarVisible || self.state == SearchBarHasContent){
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window endEditing:YES];
        
        if (self.delegate) {
            [self.delegate searchBar:self didEndTransitioningFromState:Normal];
        }
        self.searchField.text = nil;
        self.state = Transitioning;
        [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
            if (self.delegate) {
                self.frame = self.originalFrame;
            }
            self.searchFrame.layer.backgroundColor = self.searchBarOffColor.CGColor;
            self.searchImageViewOff.alpha = 1.0;
            self.searchImageViewOn.alpha = 0.0;
            self.searchField.alpha = 0.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kINSSearchBarAnimationStepDuration * 2 animations:^{
                self.searchFrame.layer.borderColor = [[UIColor clearColor]CGColor];
            } completion:^(BOOL finished) {
                self.searchImageCircle.frame = CGRectMake(0.0, 0.0, 18.0, 18.0);
                self.searchImageCrossLeft.frame = CGRectMake(14.0, 14.0, 8.0, 8.0);
                self.searchImageCircle.alpha = 0.0;
                self.searchImageCrossLeft.alpha = 0.0;
                self.searchImageCrossRight.alpha = 0.0;
                self.state = Normal;
                if (self.delegate) {
                    [self.delegate searchBar:self didEndTransitioningFromState:SearchBarVisible];
                }
            }];
        }];
    }
}

-(void)setSearchBarOnColor:(UIColor *)searchBarOnColor {
    _searchBarOnColor = searchBarOnColor;
    self.searchFrame.layer.backgroundColor = _searchBarOnColor.CGColor;
}
-(void)setSearchBarOffColor:(UIColor *)searchBarOffColor{
    _searchBarOffColor = searchBarOffColor;
    self.searchFrame.layer.backgroundColor = _searchBarOffColor.CGColor;
}
-(void)setSearchOffColor:(UIColor *)searchOffColor {
    _searchOffColor = searchOffColor;
    self.searchImageViewOff.tintColor = self.searchOffColor;
}
-(void)setSearchOnColor:(UIColor *)searchOnColor {
    _searchOnColor = searchOnColor;
    self.searchImageViewOn.tintColor = self.searchOnColor;
    self.searchImageCrossLeft.tintColor = self.searchOnColor;
    self.searchImageCrossRight.tintColor = self.searchOnColor;
    self.searchImageCircle.tintColor = self.searchOnColor;
    self.searchField.textColor = self.searchOnColor;
}

@end
