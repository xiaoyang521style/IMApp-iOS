//
//  FoldingCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/5.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "FindContactsCell.h"
@interface FindContactsCell()
@property (nonatomic, strong) UIView * infoView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIImageView *leftIconImgView;
@property (nonatomic, strong) UILabel *leftNameLa;
@property (nonatomic, strong) UIImageView *leftSexImgView;

@property (nonatomic, strong) UIImageView *infoImgView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *infoViewNameLa;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIButton *requestBtn;
@end

@implementation FindContactsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.itemCount = 4;
        self.foregroundView = [self createForegroundView];
        self.containerView = [self createContainerView];
        [self commonInit];
    }
    return self;
}

- (HSRotatedView *)createForegroundView{
    HSRotatedView * foregroundView = [[HSRotatedView alloc] initWithFrame:CGRectZero];
    foregroundView.backgroundColor = [UIColor redColor];
    foregroundView.translatesAutoresizingMaskIntoConstraints = NO;
    foregroundView.clipsToBounds = YES;
    foregroundView.layer.cornerRadius = 10;
    
    [foregroundView addSubview:self.leftView];
    [self.contentView addSubview:foregroundView];
    
    //layout
    NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:foregroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8];
    self.foregroundViewTop = topConstraint;
    
    [self.contentView addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:foregroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:17],
                                       [NSLayoutConstraint constraintWithItem:foregroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-17],
                                       topConstraint
                                       ]
     ];
    
    [foregroundView addConstraint:[NSLayoutConstraint constraintWithItem:foregroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:165]];
    [foregroundView layoutIfNeeded];
    return foregroundView;
}

- (UIView *)createContainerView{
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 10;
    containerView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.infoView];
    [self.contentView addSubview:containerView];
    
    //layout
    NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:181];
    self.containerViewTop = topConstraint;
    
    [self.contentView addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:17],
                                       [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-17],
                                       topConstraint
                                       ]
     ];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:480]];
    
    [containerView layoutIfNeeded];
    return containerView;
}
- (NSTimeInterval)animationDuration:(NSInteger)itemIndex type:(AnimationType)type{
    //timing animation for each view
    NSArray * durations = @[@0.33, @0.26, @0.26];
    return [durations[itemIndex] doubleValue];
}

- (UIView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIView alloc]init];
        _leftView.backgroundColor = [UIColor colorWithRed:93.0 / 255 green:74.0 / 255 blue:153.0 / 255 alpha:1.0];
        _leftView.frame = CGRectMake(0, 0, 88, 165);
        [_leftView addSubview:self.leftIconImgView];
        [_leftView addSubview:self.leftNameLa];
        [_leftView addSubview:self.leftSexImgView];
    }
    return _leftView;
}
-(UIImageView *)leftIconImgView {
    if (_leftIconImgView == nil) {
        _leftIconImgView = [[UIImageView alloc]init];
        _leftIconImgView.frame = CGRectMake(20, 20, 48, 48);
    }
    return _leftIconImgView;
}
-(UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}
-(UILabel *)leftNameLa {
    if (_leftNameLa == nil) {
        _leftNameLa = [[UILabel alloc]init];
        _leftNameLa.frame = CGRectMake(5, CGRectGetHeight(self.leftView.frame) - 50, 78, 30);
        _leftNameLa.textColor = [UIColor whiteColor];
        _leftNameLa.font = [UIFont systemFontOfSize:12];
        _leftNameLa.textAlignment = NSTextAlignmentCenter;
    }
    return _leftNameLa;
}
-(UIImageView *)leftSexImgView {
    if (_leftSexImgView == nil) {
        _leftSexImgView = [[UIImageView alloc]init];
        _leftSexImgView.frame =  CGRectMake(34, CGRectGetMaxY(self.leftIconImgView.frame) + 13, 17, 17);
    }
    return _leftSexImgView;
}
-(UIImageView *)infoImgView {
    if (_infoImgView == nil) {
        _infoImgView = [[UIImageView alloc]init];
    }
    return _infoImgView;
}
-(UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _line;
}
- (UIView *)infoView{
     if(_infoView == nil){
         _infoView = [[UIView alloc]init];
         _infoView.backgroundColor = [UIColor whiteColor];
         _headerView = [[UIView alloc]init];
         _headerView.backgroundColor = [UIColor colorWithRed:93.0 / 255 green:74.0 / 255 blue:153.0 / 255 alpha:1.0];
         _infoViewNameLa = [[UILabel alloc]init];
         _infoViewNameLa.font = [UIFont systemFontOfSize:14];
         _infoViewNameLa.textColor = [UIColor whiteColor];
         _infoViewNameLa.textAlignment = NSTextAlignmentCenter;
         [_headerView addSubview:_infoViewNameLa];
         
         [_infoView addSubview:self.requestBtn];
         [_infoView addSubview:self.line];
         [_infoView addSubview:self.infoImgView];
         [_infoView addSubview:self.iconView];
         [_infoView addSubview:_headerView];
     }
    return _infoView;
}

-(UIButton *)requestBtn {
    if (_requestBtn == nil) {
        _requestBtn = [[UIButton alloc]init];
    
        [_requestBtn addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
        [_requestBtn setTitleColor:[UIColor colorWithCSS:@"#5E491D"] forState:UIControlStateNormal];
        _requestBtn.backgroundColor = [UIColor colorWithCSS:@"#FCBD33"];
        _requestBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _requestBtn.layer.cornerRadius = 5;
        _requestBtn.clipsToBounds = YES;
    }
    return _requestBtn;
}
-(void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.leftNameLa.text = dict[@"username"];
    self.infoViewNameLa.text = @"个人信息";
    NSString *url = dict[@"icon"];
    NSString *sex = dict[@"sex"];
    UIImage *sexImg;
    if ([sex isEqualToString:@"女"]) {
       sexImg = [UIImage imageWithFont:ic_women size:12 color:[UIColor whiteColor]];
    }else{
       sexImg = [UIImage imageWithFont:ic_men size:12 color:[UIColor whiteColor]];
    }
    BOOL added = [dict[@"added"] boolValue];
    if (added) {
        [_requestBtn setTitle:@"去聊天" forState:UIControlStateNormal];
    }else{
        [_requestBtn setTitle:@"加为好友" forState:UIControlStateNormal];
    }
    
    self.leftSexImgView.image = sexImg;
    __weak typeof(self) weakself = self;
    [self.leftIconImgView setImageWithURL:[NSURL URLWithString:url]
                   placeholder:nil
                       options:YYWebImageOptionSetImageWithFadeAnimation
                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                          NSLog(@"图片的size :%ld  ,期望的尺寸：%ld",(long)receivedSize,(long)expectedSize);
                      }
                     transform:^UIImage *(UIImage *image, NSURL *url) {
                         
                         return [image imageByRoundCornerRadius:10];
                     }
                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                        
                        [weakself.leftIconImgView  setImage:image];
                        if (from == YYWebImageFromDiskCache) {
                            NSLog(@"load from disk cache");
                        }
                    }];

    [self.iconView setImageWithURL:[NSURL URLWithString:url]
                              placeholder:nil
                                  options:YYWebImageOptionSetImageWithFadeAnimation
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     NSLog(@"图片的size :%ld  ,期望的尺寸：%ld",(long)receivedSize,(long)expectedSize);
                                 }
                                transform:^UIImage *(UIImage *image, NSURL *url) {
                                    
                                    return [image imageByRoundCornerRadius:10];
                                }
                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                   
                                   [weakself.iconView  setImage:image];
                                   if (from == YYWebImageFromDiskCache) {
                                       NSLog(@"load from disk cache");
                                   }
                               }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.infoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 34, self.containerView.bounds.size.height);
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 34, 49);
    self.infoViewNameLa.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 34)/2 -100, 0, 200 , 49);
    self.infoImgView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), [UIScreen mainScreen].bounds.size.width - 34, 116);
    self.iconView.frame = CGRectMake(22, CGRectGetMaxY(self.infoImgView.frame) + 28, 49, 49);
    self.line.frame = CGRectMake(22, CGRectGetMaxY(self.iconView.frame) + 15, [UIScreen mainScreen].bounds.size.width - 34 - 44, 1);
    self.requestBtn.frame = CGRectMake(22, 480 - 41 - 28, [UIScreen mainScreen].bounds.size.width - 34 - 44 , 41);
}
-(void)addContacts:(UIButton *)btn {
    if ([self.dict[@"added"] boolValue]) {
    }else{
        [[SocketClient get]manageFriend:[Context get].userId friendId:[self.dict[@"userId"] intValue] type:1];
    }
}
@end
