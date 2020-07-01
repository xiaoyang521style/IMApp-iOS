//
//  ChatMessageTableViewController.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/6/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatMessageTableViewController.h"
#import "XHMacro.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHAudioPlayerHelper.h"
#import "YBImageBrowser.h"
#import "HXPhotoPicker.h"
#import "VideoServer.h"
#import "HXPhotoTools.h"
#import "Util.h"
@interface ChatMessageTableViewController ()<XHAudioPlayerHelperDelegate>
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, strong)ChatMessageViewModel *viewModel;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic, strong) NSArray *emotionManagers;
@end

@implementation ChatMessageTableViewController

- (instancetype)initWithUser:(User *)user roomId:(NSString *)roomId {
    if (self = [super init]) {
        _viewModel = [[ChatMessageViewModel alloc] initWithUser:user roomId:roomId];
        _roomId = roomId;
        [[SocketClient get]iReadRoomId:roomId friendId:(int)user.Id];
        [[RealmTable get]updateRead:user.Id];
        NotificationCenterAddObserver(self, @selector(newMessage:), NOTIFICATION_NEWMESSAGE, nil);
    }
    return self;
}

-(void)newMessage:(NSNotification *)notif {
      ChatRecord *chatRecord = notif.object;
       if (chatRecord.fromUserId == self.viewModel.user.Id) {
            XHMessage *message = [self.viewModel handelChatRecord:chatRecord];
            [self addMessage:message];
       }
}

- (void)dealloc {
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    self.emotionManagers = nil;
    NotificationCenterRemoveObserver(self, NOTIFICATION_NEWMESSAGE, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
}
-(void)setNavigationBackBar {
    UIImage *image = [UIImage imageWithFont:ic_arrow_left  size:27 color:[UIColor darkGrayColor]];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(closeController)]];
}
-(void)closeController{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackBar];
    // Do any additional setup after loading the view.
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    }
    self.navigationItem.title = self.viewModel.user.name;
//    self.messageSender = @"Jack";
    self.messages = self.viewModel.messages;
    [self.messageTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
             [self scrollToBottomAnimated:NO];
    });
   
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_friendcard", @"sharemore_myfav", @"sharemore_wxtalk", @"sharemore_videovoip", @"sharemore_voiceinput", @"sharemore_openapi", @"sharemore_openapi", @"avatar"];
    NSArray *plugTitle = @[@"照片", @"拍摄", @"位置", @"名片", @"我的收藏", @"实时对讲机", @"视频聊天", @"语音输入", @"大众点评", @"应用", @"曾宪华"];
    
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < 18; j ++) {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld.gif", (long)j] ofType:@""];
            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
            [emotions addObject:emotion];
        }
        emotionManager.emotions = emotions;
        
        [emotionManagers addObject:emotionManager];
    }
    
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
}
#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:{
            [self chatVideoMessageCellPlayVideoClick:messageTableViewCell];
        }
        break;
        case XHBubbleMessageMediaTypePhoto: {
            [self chatImageMessageCellDidClickImage:messageTableViewCell];
        }
        break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
            }
        }
        break;
        case XHBubbleMessageMediaTypeEmotion: {
            
        }
        case XHBubbleMessageMediaTypeLocalPosition: {
            break;
        }
        default:
            break;
    }
    
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)chatImageMessageCellDidClickImage:(XHMessageTableViewCell *)cell {
    YBImageBrowserModel *model0 = [YBImageBrowserModel new];
  
    if (cell.messageBubbleView.message.sender) {
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *originPhotoPath = [NSString stringWithFormat:@"%@/%@",docsdir,cell.messageBubbleView.message.originPhotoPath];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:originPhotoPath];
        [model0 setImage:image];
    }else{
        UIImage *image = cell.messageBubbleView.message.photo;
        [model0 setImage:image];
        model0.url = [NSURL URLWithString:cell.messageBubbleView.message.originPhotoUrl];
    }
    
    cell.messageBubbleView.bubblePhotoImageView.imageView.hidden = NO;
    model0.sourceImageView = cell.messageBubbleView.bubblePhotoImageView.imageView;
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
-(void)chatVideoMessageCellPlayVideoClick:(XHMessageTableViewCell *)cell{
    
    YBImageBrowserModel *model0 = [YBImageBrowserModel new];
    [model0 setImage:cell.messageBubbleView.message.videoConverPhoto];
    //model0.url = [NSURL URLWithString:imageMessage.imageUrl];
    model0.sourceImageView =  cell.messageBubbleView.bubblePhotoImageView.imageView;
    model0.type = 1;
    
    if (cell.messageBubbleView.message.bubbleMessageType == XHBubbleMessageTypeSending) {
        model0.videoUrl = [NSURL fileURLWithPath:cell.messageBubbleView.message.videoPath];
    }else{
        model0.videoUrl = [NSURL URLWithString:cell.messageBubbleView.message.videoUrl];
    }
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
/*
*  发送文本消息的回调方法
*
*  @param text   目标文本字符串
*  @param sender 发送者的名字
*  @param date   发送时间
*/
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
    textMessage.avatarUrl = [Context get].icon;
    textMessage.avatar = [UIImage imageNamed:@"avatar"];
    [self addMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];

    [self.viewModel sendText:text date:date block:^(BOOL suceess, XHMessage *message) {
        
    }];
}


/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo originPhotoPath:(NSString *)originPhotoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo originPhotoPath:originPhotoPath thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    photoMessage.avatar = [UIImage imageNamed:@"avatar"];
    photoMessage.avatarUrl =[Context get].icon;
    [self addMessage:photoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
    
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = [Context get].icon;
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *voiceMessage = [[XHMessage alloc]initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:@"" timestamp:date];
    voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
    voiceMessage.avatarUrl = [Context get].icon;
    [self addMessage:voiceMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
    
    [self.viewModel sendVoicePath:voicePath date:date duration:[voiceDuration longValue] block:^(BOOL suceess, XHMessage *message) {
        
    }];
}
/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}
/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
//- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
//    return YES;
//}



#pragma mark - XHShareMenuView Delegate

- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            
            HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
            manager.configuration.openCamera = NO;
            manager.configuration.saveSystemAblum = YES;
            manager.configuration.lookLivePhoto = YES;
            manager.configuration.selectTogether = NO;
            manager.configuration.photoMaxNum = 6;
            manager.configuration.videoMaxNum = 1;
//            manager.configuration.maxNum = 1;
            manager.configuration.open3DTouchPreview = YES;
            manager.configuration.themeColor = [UIColor blackColor];
            [self hx_presentAlbumListViewControllerWithManager:manager delegate:self];
            
        }
            break;
        
        default:
            break;
    }
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
           
            [HXPhotoTools getImageByAsset:model.asset makeSize:PHImageManagerMaximumSize makeResizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image) {
                [Util dispatchMainAsync:^{
                    [weakSelf.viewModel sendThumbImage:model.thumbPhoto previewImage:model.thumbPhoto asset:model.asset date:[NSDate new] block:^(BOOL suceess, XHMessage *message) {
                        [weakSelf didSendPhoto:model.thumbPhoto originPhotoPath:message.originPhotoPath fromSender:@"" onDate:[NSDate new]];
                    }];
                }];
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
                            [weakSelf.viewModel sendVideo:beforeVideoData image:model.thumbPhoto date:[NSDate new] asset:model.asset  block:^(BOOL suceess, XHMessage *message) {
                                [Util dispatchMainAsync:^{
                                    [weakSelf didSendVideoConverPhoto:message.videoConverPhoto videoPath:message.videoPath fromSender:@"" onDate:message.timestamp];
                                    
                                }];
                            }];
                           
                        }else{
                            [weakSelf.viewModel sendVideo:resultData image:model.thumbPhoto date:[NSDate new] asset:model.asset block:^(BOOL suceess, XHMessage *message) {
                           [Util dispatchMainAsync:^{
                               [weakSelf didSendVideoConverPhoto:message.videoConverPhoto videoPath:message.videoPath fromSender:@"" onDate:message.timestamp];
                          
                           }];
                           }];
                        }
                    }];
                }];
            } else{
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
