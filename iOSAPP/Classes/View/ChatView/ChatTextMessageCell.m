//
//  ChatTextMessageCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/17.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatTextMessageCell.h"
#import "TextMessage.h"
@interface ChatTextMessageCell ()
@property(nonatomic,strong)UILabel *messageLabel;
@end

@implementation ChatTextMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
    }
    return self;
}

-(void)updateDirection:(MessageDirection)direction{
    [super updateDirection:direction];
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (direction == MessageDirection_RECEIVE) {
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 10));
        }else{
            make.edges.mas_offset(UIEdgeInsetsMake(10, 10, 10, 15));
        }
    }];
}
-(void)updateMessage:(Message *)message showDate:(BOOL)showDate{
    [super updateMessage:message showDate:showDate];
    TextMessage *textMessage = (TextMessage *)message.content;
    self.messageLabel.text = textMessage.content;
}
-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.textColor = UIColorFromRGB(0x333333);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}
@end
