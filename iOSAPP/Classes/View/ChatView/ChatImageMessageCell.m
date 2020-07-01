//
//  ChatImageMessageCell.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/17.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatImageMessageCell.h"
#import <UIImageView+WebCache.h>
#import "ImageMessage.h"
#import "ChatPhotoBrowser.h"
static  CGFloat fitImgWidth  = 150;
static  CGFloat fitImgHeight = 150;
static int tagOfImageOfCell = 1000;

@interface ChatImageMessageCell ()
@property(nonatomic,strong)UIImageView *imageViewMask;
@end

@implementation ChatImageMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bubbleImageView);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage)];
        [self.photoImageView addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)didClickImage{
    if([self.delegate respondsToSelector:@selector(chatImageMessageCellDidClickImage:)]){
        [self.delegate chatImageMessageCellDidClickImage:self];
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
    ImageMessage *imgMessage = (ImageMessage *)message.content;
    if (imgMessage.thumbnailImage) {
        self.photoImageView.image = imgMessage.thumbnailImage;
        [self updateLayout];
    }else{
        if (message.messageDirection == MessageDirection_SEND) {
            NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *dataFilePath = [docsdir stringByAppendingPathComponent:imgMessage.thumbImageUrl];
            UIImage *image = [UIImage imageWithContentsOfFile:dataFilePath];
            self.photoImageView.image = image;
            imgMessage.thumbnailImage = image;
            imgMessage.originalImage = image;
            [self updateLayout];
        }else{
            [self.photoImageView sd_setImageWithURL: [NSURL URLWithString:imgMessage.thumbImageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    imgMessage.thumbnailImage = image;
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
