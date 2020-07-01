//
//  ChatPhotoBrowser.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageScrollView;

@protocol ImageScrollViewDelegate <NSObject>
@optional
-(void)imageScrollViewLongTap:(UILongPressGestureRecognizer *)sender;
-(void)imageScrollViewTap:(UITapGestureRecognizer *)sender;
@end

@interface ChatPhotoBrowser : UIView
@property(nonatomic,strong)ImageScrollView *imageScrollView;
+(void)showOriginalImage:(UIImage *)originalImage;
@end

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>
@property(nonatomic,assign)id <ImageScrollViewDelegate> actionDelegate;
@property(nonatomic,strong)UIImage *img;
@end
