//
//  ChatVideoMessageCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/17.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatVideoMessageCell.h"
#import <UIImageView+WebCache.h>
#import "VideoMessage.h"
#import "HXPhotoTools.h"
static  CGFloat fitImgWidth  = 150;
static  CGFloat fitImgHeight = 150;
static int tagOfImageOfCell = 1000;

@interface ChatVideoMessageCell ()
@property(nonatomic,strong)UIImageView *imageViewMask;
@property(nonatomic,strong)UIImageView *playIcon;
@end

@implementation ChatVideoMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView addSubview:self.photoImageView];
        [self.photoImageView addSubview:self.playIcon];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bubbleImageView);
        }];
        [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(@(CGSizeMake(30, 30)));
            make.center.mas_equalTo(CGPointMake(0, 0));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage)];
        [self.photoImageView addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)didClickImage{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatVideoMessageCellPlayVideoClick:)]) {
        [self.delegate chatVideoMessageCellPlayVideoClick:self];
    }
}
-(void)updateLayout {
    CGSize imgSize = self.photoImageView.image.size;
    CGFloat scale = imgSize.width / imgSize.height;
    
    CGFloat newWidth  = MAX(MIN(imgSize.width, fitImgWidth), fitImgWidth);
    CGFloat newHeight = MAX(MIN(imgSize.height, fitImgHeight), fitImgHeight);
    
    CGSize newSize = scale > 1 ? CGSizeMake(newWidth, newWidth / scale) : CGSizeMake(newHeight * scale, newHeight);
    
    self.imageViewMask.image = self.bubbleImageView.image;
    self.imageViewMask.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    self.photoImageView.layer.mask = self.imageViewMask.layer;
    [self.photoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(newSize);
    }];
}

-(void)updateMessage:(Message *)message showDate:(BOOL)showDate{
    [super updateMessage:message showDate:showDate];
    VideoMessage *videoMessage = (VideoMessage *)message.content;
    if (videoMessage.thumbnailImage) {
        self.photoImageView.image = videoMessage.thumbnailImage;
        [self updateLayout];
    }else{
        if (message.messageDirection == MessageDirection_SEND) {
            NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *dataFilePath = [docsdir stringByAppendingPathComponent:videoMessage.imageUrl];
            UIImage *image = [UIImage imageWithContentsOfFile:dataFilePath];
            self.photoImageView.image = image;
            videoMessage.thumbnailImage = image;
            [self updateLayout];
        }else{
            [self.photoImageView sd_setImageWithURL: [NSURL URLWithString:videoMessage.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    videoMessage.thumbnailImage = image;
                    [self updateLayout];
                }
            }];
        }
    }
}
-(UIImageView *)imageViewMask{
    if (!_imageViewMask) {
        _imageViewMask = [[UIImageView alloc] init];
    }
    return _imageViewMask;
}
-(UIImageView *)playIcon {
    if (_playIcon == nil) {
        _playIcon = [[UIImageView alloc]init];
        _playIcon.image = [HXPhotoTools hx_imageNamed:@"multimedia_videocard_play@2x.png"];
    }
    return _playIcon;
}
-(UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_photoImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _photoImageView.tag = tagOfImageOfCell;
    }
    return _photoImageView;
}
@end
