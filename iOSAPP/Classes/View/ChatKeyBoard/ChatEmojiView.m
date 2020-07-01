//
//  ChatEmojiView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatEmojiView.h"
#import "UIView+FrameTool.h"
#import "ChatEmojiCell.h"
#define kCollectionViewHeight 176.0
@interface ChatEmojiView ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
,ChatEmojiCellDelegate>
{
    NSDictionary *faces;
    CGSize itemSize;
    UIButton *sendButton;
    UISegmentedControl *segmentControl;
}
@property(nonatomic, readonly) UICollectionView *menuCollectionView;
@end

@implementation ChatEmojiView

@synthesize menuCollectionView;

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initMenu];
    }
    return self;
}
-(void)initMenu{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, kCollectionViewHeight) collectionViewLayout:flowLayout];
    menuCollectionView.backgroundColor = [UIColor whiteColor];
    menuCollectionView.delegate = self;
    menuCollectionView.dataSource = self;
    menuCollectionView.pagingEnabled = YES;
    menuCollectionView.showsHorizontalScrollIndicator = NO;
    menuCollectionView.showsVerticalScrollIndicator = NO;
    [menuCollectionView registerClass:[ChatEmojiCell class] forCellWithReuseIdentifier:@"EmojiCollectionViewCell"];

    CGFloat width = (menuCollectionView.frame.size.width - 80) / 8;
    CGFloat height = menuCollectionView.frame.size.height / 5;
    itemSize = CGSizeMake(width, height);

    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width - 70, kCollectionViewHeight+5, 60, 30)];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sendButton setBackgroundColor:MianColor];
    sendButton.layer.cornerRadius=6;
    [sendButton addTarget:self action:@selector(onSendPress:) forControlEvents:UIControlEventTouchUpInside];

   

    NSString *path = [[NSBundle mainBundle] pathForResource:@"faces" ofType:@"plist"];
    faces = [NSDictionary dictionaryWithContentsOfFile:path];

    NSMutableArray *segments = [[NSMutableArray alloc] init];
    NSArray *emojis = faces[@"emojis"];

    for (NSDictionary *e in emojis)
        [segments addObject:e[@"type"]];
    segmentControl = [[UISegmentedControl alloc] initWithItems:segments];
    segmentControl.frame = CGRectMake(10, kCollectionViewHeight + 5, screenRect.size.width - 100, 30);
    segmentControl.tintColor = [UIColor grayColor];
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:sendButton];
    [self addSubview:segmentControl];
    [self addSubview:menuCollectionView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return ((NSArray*)faces[@"emojis"]).count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = ((NSArray*)[((NSArray*)faces[@"emojis"]) objectAtIndex:section][@"faces"]).count;
    
    if (count%32 != 0) {
        count += 32 - count%32;
    }
    
    return count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GradientCell = @"EmojiCollectionViewCell";
    ChatEmojiCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:GradientCell forIndexPath:indexPath];
    cell.text = @"";
    cell.deleteButton.hidden = YES;
    cell.label.hidden = YES;
    cell.delegate = self;
    if (indexPath.row > 0 && (indexPath.row+1) % 32 == 0) {
        cell.deleteButton.hidden = NO;
        return cell;
    }
    
    if (indexPath.row > ((NSArray*)[((NSArray*)faces[@"emojis"]) objectAtIndex:indexPath.section][@"faces"]).count-1) {
        return cell;
    }
    cell.label.hidden = NO;
    NSString *text = [self emojiAtIndexPath:indexPath];
    cell.label.text = text;
    cell.text  = text;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0)
        return UIEdgeInsetsMake(0, 5, 0, 0);
    else
        return UIEdgeInsetsMake(0, 10, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        NSString *text = [self emojiCellAtIndexPath:indexPath];
        if (text && ![text isEqualToString:@""])
            [self.delegate emojiView:self didPressFaceValue:text];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (segmentControl.selectedSegmentIndex != indexPath.section)
        segmentControl.selectedSegmentIndex = indexPath.section;
}
- (void)selectSegment:(id)sender {
    [menuCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:segmentControl.selectedSegmentIndex] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (NSString*)emojiAtIndexPath:(NSIndexPath*)indexPath {
    return [((NSArray*)[((NSArray*)faces[@"emojis"]) objectAtIndex:indexPath.section][@"faces"]) objectAtIndex:indexPath.row];
}

- (NSString*)emojiCellAtIndexPath:(NSIndexPath*)indexPath {
    ChatEmojiCell *cell = (ChatEmojiCell *)[menuCollectionView cellForItemAtIndexPath:indexPath];
    return cell.text;
}
-(void)emojiCellDidPressDeleteButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiViewDidPressDeleteButton:)]) {
        [self.delegate emojiViewDidPressDeleteButton:self];
    }
}

- (void)onSendPress:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiViewDidPressSendButton:)]) {
        [self.delegate emojiViewDidPressSendButton:self];
    }
}

+ (BOOL)isEmojisWithHeightChar:(const unichar)hs
                    andLowChar:(const unichar)ls {
    if (0xd800 <= hs && hs <= 0xdbff) {
        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
        if (0x1d000 <= uc && uc <= 0x1f77f)
            return YES;
    } else if (ls == 0x20e3) {
        return YES;
    }
    return NO;
}
@end
