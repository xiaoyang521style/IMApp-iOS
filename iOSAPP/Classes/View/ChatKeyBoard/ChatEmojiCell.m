//
//  EmojiCollectionViewCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatEmojiCell.h"

@implementation ChatEmojiCell

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}
-(UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.frame];
        label.font = [UIFont systemFontOfSize:MIN(self.contentView.frame.size.height, self.contentView.frame.size.width)-5];
        label.textAlignment = NSTextAlignmentCenter;
        
        _label = label;
        [self.contentView addSubview:_label];
    }
    return _label;
}
-(UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 20)/2, 30, 20)];
        [_deleteButton setBackgroundImage:[UIImage imageWithPathOfName:@"chat_keyborad_delete.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDeletePress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
    }
    return _deleteButton;
}
- (void)onDeletePress:(id)sender {
    [self.delegate emojiCellDidPressDeleteButton];
}
@end
