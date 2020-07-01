//
//  EmojiCollectionViewCell.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatEmojiCellDelegate
-(void)emojiCellDidPressDeleteButton;
@end

@interface ChatEmojiCell : UICollectionViewCell
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak) id<ChatEmojiCellDelegate>delegate;
@end
