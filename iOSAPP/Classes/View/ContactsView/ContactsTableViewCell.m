//
//  ContactsTableViewCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ContactsTableViewCell.h"

@interface ContactsTableViewCell()

@property(nonatomic, strong)UIImageView *icon;
@property(nonatomic, strong)UILabel *nameLa;
@property(nonatomic, strong)UIView *line;
@end

@implementation ContactsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.nameLa];
}
-(UILabel *)nameLa {
    if (_nameLa == nil) {
        _nameLa = [[UILabel alloc]init];
        _nameLa.font = [UIFont systemFontOfSize:15];
    }
    return _nameLa;
}
-(UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightTextColor];
    }
    return _line;
}

-(UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(0);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(@1);
    }];
    [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(0);
    }];
}
-(void)setContact:(Contacts *)contact {
  
    _contact = contact;
    self.nameLa.text = _contact.username;
    NSURL *url = [NSURL URLWithString:_contact.icon];
    __weak typeof(self) weakself = self;
    [self.icon setImageWithURL:url
                      placeholder:nil
                          options:YYWebImageOptionSetImageWithFadeAnimation
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             NSLog(@"图片的size :%ld  ,期望的尺寸：%ld",(long)receivedSize,(long)expectedSize);
                         }
                        transform:^UIImage *(UIImage *image, NSURL *url) {
                            
                            return [image imageByRoundCornerRadius:10];
                        }
                       completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                           
                           [weakself.icon setImage:image];
                           if (from == YYWebImageFromDiskCache) {
                               NSLog(@"load from disk cache");
                           }
                       }];
}
@end
