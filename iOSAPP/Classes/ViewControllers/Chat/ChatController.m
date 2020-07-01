//
//  ChatViewController.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatController.h"
#import "UIColor+Help.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "ChatBottomView.h"
#import "ChatViewModel.h"
#import "User.h"
#import <DateTools/NSDate+DateTools.h>
#import <Qiniu/QiniuSDK.h>
#import "ChatKeyboardView.h"
#import "UIView+FrameTool.h"
#import "InternalClock.h"
#import "ChatTextMessageCell.h"
#import "ChatVoiceMessagCell.h"
#import "ChatLocationMessageCell.h"
#import "ChatImageMessageCell.h"
#import "ChatVideoMessageCell.h"
#import "ChatMessageCell.h"
#import "Message.h"
#import "HXPhotoPicker.h"
#import "YBImageBrowser.h"
#import "VideoServer.h"
#import "ImageMessage.h"
#import "VideoMessage.h"
@interface ChatController ()<UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
UIGestureRecognizerDelegate,
ChatKeyboardDelegate,
HXAlbumListViewControllerDelegate,
ChatMessageCellDelegate>
{
   NSIndexPath *currentTouchIndexPath;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChatKeyboardView *bottomView;

@property (nonatomic, strong) ChatViewModel *viewModel;
@property (nonatomic, assign) BOOL keyboardShowed;

@property (nonatomic, copy) NSString *roomId;
@end

@implementation ChatController

- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId{
    if (self = [super init]) {
        _viewModel = [[ChatViewModel alloc] initWithUser:user roomId:roomId];
        _roomId = roomId;
        [[SocketClient get]iReadRoomId:roomId friendId:(int)user.Id];
        [[RealmTable get]updateRead:user.Id];
        NotificationCenterAddObserver(self, @selector(newMessage:), NOTIFICATION_NEWMESSAGE, nil);
    }
    return self;
}
-(void)dealloc {
    NotificationCenterRemoveObserver(self, NOTIFICATION_NEWMESSAGE, nil);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollTableToFoot:NO];
}
-(void)newMessage:(NSNotification *)notif {
    ChatRecord *chatRecord = notif.object;
    if (chatRecord.fromUserId == self.viewModel.user.Id ||chatRecord.toUserId == self.viewModel.user.Id) {
        Message *message = [self.viewModel handelChatRecord:chatRecord];
        [self.viewModel.messages addObject:message];
        [self.tableView insertRowsAtIndexPaths:@[[self lastMessageIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
        [self scrollTableToFoot:YES];
        if(chatRecord.fromUserId == self.viewModel.user.Id){
            [[SocketClient get]iReadRoomId:self.roomId friendId:(int)self.viewModel.user.Id];
            [[RealmTable get]updateRead:self.viewModel.user.Id];
            NSDictionary *chatRecordDict = @{@"needUpateReadCount":@false,@"chatRecord":chatRecord};
            NotificationCenterPost(NOTIFICATION_RELOADSESSION, chatRecordDict, nil);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)loadView {
    [super loadView];
    
    [self defineLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    self.title = self.viewModel.user.name;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addView {
     [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    //给UITableView添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)defineLayout {
    CGRect rect = self.view.bounds;
    self.tableView.frame = CGRectMake(0, 0, rect.size.width, self.bottomView.y);
}

#pragma mark - operating methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
}

- (void)scrollTableToFoot:(BOOL)animated {
    [self.view layoutIfNeeded];
    NSInteger r = self.viewModel.messages.count;
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:0];
    dispatch_group_t downloadGroup = dispatch_group_create();
    dispatch_group_enter(downloadGroup);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.tableView reloadData];
        dispatch_group_leave(downloadGroup);
    });
    
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    });
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   Message *msg = self.viewModel.messages[indexPath.row];
   Message *lastMsg = [self lasetMsgWithIndex:indexPath.row];
//
   CGFloat height = [tableView fd_heightForCellWithIdentifier:[self cellIdentifierWithMsg:msg] cacheByIndexPath:indexPath configuration:^(ChatMessageCell *cell) {
        [cell updateMessage:msg showDate:(msg.sentTime - lastMsg.sentTime > 60 * 5 * 1000)];
    }];
    return 100;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *msg = self.viewModel.messages[indexPath.row];
    Message *lastMsg = [self lasetMsgWithIndex:indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
    ChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierWithMsg:msg]forIndexPath:indexPath];
    weakifySelf;
    cell.reSendAction = ^(Message *msg){
        strongifySelf;
        msg.sentStatus = SentStatus_SENDING;
        [self retrySendMessage:msg];
    };
    cell.delegate = self;
    cell.clickAvatar = ^(MessageDirection msgDirection){

    };
    [cell updateMessage:msg showDate:(msg.sentTime - lastMsg.sentTime > 60 * 5 * 1000)];
    
    if (msg.messageDirection ==  MessageDirection_SEND ) {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[Context get].icon] placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon.png"]];
    }

    if (msg.messageDirection ==  MessageDirection_RECEIVE) {
          [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.user.avatar] placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon.png"]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (void)retrySendMessage:(Message *)message{

}

#pragma mark - ChatKeyboardDelegate

//发送的文案
- (void)textViewContentText:(NSString *)textStr{
    __weak typeof(self) weakSelf = self;
    [self.viewModel sendText:textStr block:^(BOOL suceess, Message *message) {
        if (suceess) {
            [weakSelf.tableView insertRowsAtIndexPaths:@[[self lastMessageIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf scrollTableToFoot:YES];
        }
    }];
}

- (void)keyboardSelectType:(ChatMoreType)type {
    switch (type) {
        case ChatMoreTypeAlbum:
            [self goAlbum];
            break;
        default:
            break;
    }
}
- (void)goAlbum {
    NSLog(@"去相册");
   HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
   manager.configuration.openCamera = YES;
   manager.configuration.saveSystemAblum = YES;
   manager.configuration.lookLivePhoto = YES;
   manager.configuration.themeColor = [UIColor blackColor];
   [self hx_presentAlbumListViewControllerWithManager:manager delegate:self];
}
- (NSIndexPath *)lastMessageIndexPath{
    return [NSIndexPath indexPathForItem:self.viewModel.messages.count - 1 inSection:0];
}
//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
 
    // 获取对应cell的rect值（其值针对于UITableView而言）
    CGFloat lastMaxY;
    if (self.viewModel.messages.count > 0 && self.viewModel.messages) {
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.viewModel.messages.count - 1 inSection:0];
        CGRect rect = [self.tableView rectForRowAtIndexPath:lastIndex];
         lastMaxY = rect.origin.y + rect.size.height;
    }else{
         lastMaxY = 0;
    }

    //如果最后一个cell的最大Y值大于tableView的高度
    if (lastMaxY <= self.tableView.height) {
        if (lastMaxY >= minY) {
            self.tableView.y = minY - lastMaxY;
        } else {
            self.tableView.y = 0;
        }
    } else {
        self.tableView.y += minY - self.tableView.maxY;
    }
}

#pragma mark ====== 点击UITableView ======
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //收回键盘
    if (self.keyboardShowed) {
      
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
     
        [_tableView  registerClass:[ChatTextMessageCell class] forCellReuseIdentifier:@"ChatTextMessageCell"];
        [_tableView  registerClass:[ChatImageMessageCell class] forCellReuseIdentifier:@"ChatImageMessageCell"];
        [_tableView  registerClass:[ChatVoiceMessagCell class] forCellReuseIdentifier:@"ChatVoiceMessagCell"];
        [_tableView registerClass:[ChatLocationMessageCell class] forCellReuseIdentifier:@"ChatLocationMessageCell"];
        [_tableView registerClass:[ChatVideoMessageCell class] forCellReuseIdentifier:@"ChatVideoMessageCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
        if (IOS11) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(StatusBarAndNavigationBarHeight, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsMake(StatusBarAndNavigationBarHeight, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _tableView.separatorColor = UIColorFromRGB(0xeeeeee);
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

- (ChatKeyboardView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ChatKeyboardView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 56 -TabbarSafeBottomMargin , SCREEN_WIDTH, 56)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

-(Message *)lasetMsgWithIndex:(NSInteger)index{
    return index > 0 ? self.viewModel.messages[index - 1] : nil;
}

-(NSString *)cellIdentifierWithMsg:(Message *)msg{
    
    NSString *cellIdentifier;
    switch (msg.type) {
        case ChatRecordTypeText:
            cellIdentifier = @"ChatTextMessageCell";
            break;
        case ChatRecordTypeImage:
            cellIdentifier = @"ChatImageMessageCell";
            break;
            
        case ChatRecordTypeAudio:
            cellIdentifier = @"ChatVoiceMessagCell";
           
            break;
            
        case ChatRecordTypeLocation:
            cellIdentifier = @"LocationMessageCell";
            break;
            
        case ChatRecordTypeVideo:
            cellIdentifier = @"ChatVideoMessageCell";
            break;
        default:
            break;
    }
    return  cellIdentifier;
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    for (HXPhotoModel *model in allList) {
        if (model.subType == HXPhotoModelMediaSubTypePhoto) {
             __weak typeof(self) weakSelf = self;
            UIImage *photo;
            if (model.previewPhoto) {
                photo = model.previewPhoto;
            }else{
                photo = model.thumbPhoto;
            }
            [self.viewModel sendImage:photo asset:model.asset block:^(BOOL suceess, Message *message) {
                [weakSelf.tableView insertRowsAtIndexPaths:@[[self lastMessageIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf scrollTableToFoot:YES];
            }];
        }
        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
             __weak typeof(self) weakSelf = self;
              if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
                   PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                  [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                      NSURL *fileRUL = [asset valueForKey:@"URL"];
                      NSData *beforeVideoData = [NSData dataWithContentsOfURL:fileRUL];//未压缩的视频流
                      VideoServer *videoServer = [[VideoServer alloc] init];
                      [videoServer compressVideo:fileRUL andVideoName:@"video" andSave:NO successCompress:^(NSData *resultData) {
                          if (resultData == nil || resultData.length == 0 ) {
                              [self.viewModel sendVideo:beforeVideoData image:model.thumbPhoto asset:model.asset block:^(BOOL suceess, Message *message) {
                                  [weakSelf.tableView insertRowsAtIndexPaths:@[[self lastMessageIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
                                  [weakSelf scrollTableToFoot:YES];
                              }];
                          }else{
                              [self.viewModel sendVideo:resultData image:model.thumbPhoto asset:model.asset block:^(BOOL suceess, Message *message) {
                                  [weakSelf.tableView insertRowsAtIndexPaths:@[[self lastMessageIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
                                  [weakSelf scrollTableToFoot:YES];
                              }];
                          }
                      }];
                  }];
              } else{
              }
        }
    }
}


-(void)recorderVoiceWithVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration {
     __weak typeof(self)weakSelf = self;
    [self.viewModel sendVoiceData:voiceData path:path duration:duration block:^(BOOL suceess, Message *message) {
        [weakSelf.tableView insertRowsAtIndexPaths:@[[self lastMessageIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf scrollTableToFoot:YES];
    }];
}


#pragma mark 方式二、使用代理配置数据源

-(void)chatImageMessageCellDidClickImage:(ChatImageMessageCell *)cell {
    YBImageBrowserModel *model0 = [YBImageBrowserModel new];
    [model0 setImage:cell.photoImageView.image];
    ImageMessage *imageMessage = (ImageMessage *)cell.message.content;
    model0.url = [NSURL URLWithString:imageMessage.imageUrl];
    model0.sourceImageView = cell.photoImageView;
    //创建图片浏览器
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = @[model0];
    browser.currentIndex = 0;
    browser.cancelLongPressGesture = NO;
    browser.toolBar.hidden = YES;
    YBImageBrowserFunctionModel *fuction = [YBImageBrowserFunctionModel functionModelForSavePictureToAlbum];
    YBImageBrowserFunctionModel *fuction2 = [YBImageBrowserFunctionModel functionModelForSavePictureToAlbum];
    NSArray<YBImageBrowserFunctionModel *> *fuctionDataArray = @[fuction, fuction2];
    browser.fuctionDataArray = fuctionDataArray;
    [browser show];
}

-(void)chatVideoMessageCellPlayVideoClick:(ChatVideoMessageCell *)cell{
    YBImageBrowserModel *model0 = [YBImageBrowserModel new];
    [model0 setImage:cell.photoImageView.image];
    ImageMessage *imageMessage = (ImageMessage *)cell.message.content;
    model0.url = [NSURL URLWithString:imageMessage.imageUrl];
    model0.sourceImageView = cell.photoImageView;
    model0.type = 1;
    VideoMessage *videoMessage = (VideoMessage *)cell.message.content;
    NSURL *videoUrl;
    if(cell.message.messageDirection == MessageDirection_SEND) {
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataFilePath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",videoMessage.videoUrl]];
        videoUrl = [NSURL fileURLWithPath:dataFilePath];
    }else{
        videoUrl = [NSURL URLWithString:videoMessage.videoUrl];
    }
    model0.videoUrl =videoUrl  ;
    //创建图片浏览器
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = @[model0];
    browser.currentIndex = 0;
    browser.cancelLongPressGesture = NO;
    browser.toolBar.hidden = YES;
    YBImageBrowserFunctionModel *fuction = [YBImageBrowserFunctionModel functionModelForSavePictureToAlbum];
    YBImageBrowserFunctionModel *fuction2 = [YBImageBrowserFunctionModel functionModelForSavePictureToAlbum];
    NSArray<YBImageBrowserFunctionModel *> *fuctionDataArray = @[fuction, fuction2];
    browser.fuctionDataArray = fuctionDataArray;
    [browser show];
    
}
@end
