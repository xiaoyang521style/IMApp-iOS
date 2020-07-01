//
//  SessionCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/28.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SessionCell.h"
#import "NSDate+Utils.h"

@interface SessionCell()
@property(nonatomic, strong)UIImageView *iconImgView;
@property(nonatomic, strong)UILabel *nameLa;
@property(nonatomic, strong)UILabel *timeLa;
@property(nonatomic, strong)UILabel *contentLa;

@end

@implementation SessionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.nameLa];
        [self addSubview:self.timeLa];
        [self addSubview:self.iconImgView];
        [self addSubview:self.contentLa];
        [self addSubview:self.badgeLabel];
    }
    return self;
}

-(void)setModel:(SessionModel *)model {
    _model = model;
    self.nameLa.text = _model.username;
    self.contentLa.text = _model.content;
    self.timeLa.text = [self timeStr:_model.timestamp];
    
    if (_model.unReadCount > 99) {
        self.badgeLabel.text = @"99+";
        self.badgeLabel.hidden = NO;
    } if (_model.unReadCount == 0) {
        self.badgeLabel.hidden = YES;
    } else{
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",_model.unReadCount];
    }
    
    NSURL *url = [NSURL URLWithString:_model.icon];
    __weak typeof(self) weakself = self;
    [self.iconImgView setImageWithURL:url
                   placeholder:nil
                       options:YYWebImageOptionSetImageWithFadeAnimation
                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                          NSLog(@"图片的size :%ld  ,期望的尺寸：%ld",(long)receivedSize,(long)expectedSize);
                      }
                     transform:^UIImage *(UIImage *image, NSURL *url) {
                         
                         return [image imageByRoundCornerRadius:10];
                     }
                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                        
                        [weakself.iconImgView setImage:image];
                        if (from == YYWebImageFromDiskCache) {
                            NSLog(@"load from disk cache");
                        }
                    }];
}

-(UILabel *)nameLa {
    if (_nameLa == nil) {
        _nameLa = [[UILabel alloc]init];
        _nameLa.font = [UIFont systemFontOfSize:15];
    }
    return _nameLa;
}

-(UILabel *)timeLa {
    if (_timeLa == nil) {
        _timeLa = [[UILabel alloc]init];
        _timeLa.font = [UIFont systemFontOfSize:14];
        _timeLa.textColor = [UIColor lightGrayColor];
    }
    return _timeLa;
}

-(UILabel *)contentLa {
    if (_contentLa == nil) {
        _contentLa = [[UILabel alloc]init];
        _contentLa.font = [UIFont systemFontOfSize:14];
        _contentLa.textColor = [UIColor grayColor];
    }
    return _contentLa;
}

-(UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc]init];
    }
    return _iconImgView;
}

- (PPBadgeLabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [PPBadgeLabel defaultBadgeLabel];
    }
    return _badgeLabel;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.mas_equalTo(0);
    }];
    
    [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@25);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(@([self labelAutoCalculateRectWith:self.timeLa.text FontSize:14 MaxSize:CGSizeMake(100, 25)]));
    }];
    

    
    [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(8);
        make.right.equalTo(self.timeLa.mas_left).offset(-8);
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(@25);
    }];
    
    [self.contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.nameLa.mas_bottom).offset(0);
        make.height.mas_equalTo(@25);
    }];
    
    self.badgeLabel.p_right = [UIScreen mainScreen].bounds.size.width-15;
    self.badgeLabel.p_centerY = self.p_height * 0.72;

}
- (NSString *)timeStr:(long long)timestamp {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    // 判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        NSString *timeBucket = [NSDate getTheTimeBucket:msgDate];
        dateFmt.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",timeBucket];
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
        
    } else if (currentYear == msgYear && currentMonth == msgMonth && (1<currentDay - msgDay && currentDay - msgDay< 8)) {
        dateFmt.dateFormat = [msgDate toweekday];
    } else{
        //昨天以前
        dateFmt.dateFormat = @"yyyy/MM/dd";
    }
    return [dateFmt stringFromDate:msgDate];
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //根据字符串长度自适应label的宽度
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

@end
