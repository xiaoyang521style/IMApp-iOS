//
//  ChatMoreView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatMoreView.h"
#import "UIView+FrameTool.h"
#import "ChatMoreCell.h"

@interface ChatMoreView()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>{
    CGSize itemSize;
}
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation ChatMoreView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initData];
        [self initMore];
    }
    return self;
}
-(void)initData {
    NSArray *arr =@[@{@"iconName":@(ic_album),@"action":@"album",@"name":@"相册"}];
    [self.dataSource appendObjects:arr];
}
-(void)initMore {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width,  230.0 ) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView registerClass:[ChatMoreCell class] forCellWithReuseIdentifier:NSStringFromClass([ChatMoreCell class])];
    CGFloat width = (_collectionView.frame.size.width) / 4;
    CGFloat height = _collectionView.frame.size.height / 2;
    itemSize = CGSizeMake(width, height);
     [self addSubview:self.collectionView];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

        return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return itemSize;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ChatMoreCell class]) forIndexPath:indexPath];
    NSUInteger fontcode = [self.dataSource[indexPath.row][@"iconName"] unsignedLongLongValue];
    UIImage *image = [UIImage imageWithFont:fontcode size:20 color:nil];
    cell.imageView.image = image;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return self.dataSource.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSource[indexPath.row];
    NSString *action = dict[@"action"];
    if ([action isEqualToString:@"album"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatMoreViewSelectType:)]) {
            [self.delegate chatMoreViewSelectType:ChatMoreTypeAlbum];
        }
    }
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
