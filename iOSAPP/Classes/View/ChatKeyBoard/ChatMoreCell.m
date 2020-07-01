//
//  ChatMoreCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/19.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatMoreCell.h"

@interface ChatMoreCell ()

@end

@implementation ChatMoreCell
-(instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews {
    [self addSubview:self.imageView];
}
-(UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.center.mas_equalTo(CGPointMake(0, 0));
    }];
}
@end
