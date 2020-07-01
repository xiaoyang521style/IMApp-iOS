//
//  UIView+FrameTool.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameTool)
- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGSize)size;
- (void)setSize:(CGSize)size;

/**最大X*/
- (CGFloat)maxX;
/**最小X*/
- (CGFloat)minX;

/**最大Y*/
- (CGFloat)maxY;
/**最小Y*/
- (CGFloat)minY;

@end

@interface UIView (FindeFirstResponder)

/**
 找到第一响应者
 */
- (UIView *)findFirstResponder;


@end
