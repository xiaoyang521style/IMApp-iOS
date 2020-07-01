//
//  ChatKeyboardView.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ChatKeyboardView.h"
#import "ChatTextView.h"
#import "ChatRecordVoice.h"
#import "ChatEmojiView.h"
#import "UIView+FrameTool.h"
#import "ChatRecordVoiceHUD.h"
//状态栏和导航栏的总高度
#define StatusNav_Height (isIphoneX ? 88 : 64)
//判断是否是iPhoneX
#define isIphoneX (K_Width == 375.f && K_Height == 812.f ? YES : NO)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float bottomHeight = 230.0f; //底部视图高度
static float viewMargin = 10.0f; //按钮距离上边距
static float viewHeight = 36.0f; //按钮视图高度
@interface ChatKeyboardView ()<UITextViewDelegate,
ChatEmojiViewDelegate,
ChatMoreViewDelegate,
RecorderVoiceDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property(nonatomic, strong)  UIButton *tapVoiceBtn;


@property (nonatomic, strong) ChatTextView *textView;
@property (nonatomic, strong) ChatMoreView *moreView;
@property (nonatomic, strong) ChatEmojiView *emojiView;

@property (nonatomic, assign) CGFloat totalYOffset;
@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL emojiClick; //点击表情按钮
@property (nonatomic, assign) BOOL moreClick; //点击更多按钮


@property(nonatomic,strong)ChatRecordVoice *recorder;

@end

@implementation ChatKeyboardView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //监听键盘出现、消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
        
        //创建视图
        [self creatView];
    }
    return self;
}
- (void)creatView {
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    
    self.textView.backgroundColor = [UIColor colorWithRed:0.97 green:0.98 blue:0.99 alpha:1];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(viewMargin);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-viewMargin);
        make.size.mas_offset(CGSizeMake(viewHeight, viewHeight));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceBtn.mas_right).offset(viewMargin);
        make.top.equalTo(self.mas_top).offset(viewMargin);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-viewMargin);
    }];
    
    [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_right).offset(viewMargin);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-viewMargin);
        make.size.mas_offset(CGSizeMake(viewHeight, viewHeight));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emojiBtn.mas_right).offset(viewMargin/2);
        make.right.equalTo(self.mas_right).offset(-viewMargin);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-viewMargin);
        make.size.mas_offset(CGSizeMake(viewHeight, viewHeight));
    }];
    
    [self.tapVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView);
    }];
}
#pragma mark ====== 语音按钮 ======
-(void)switchVoice:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.tapVoiceBtn.hidden = !btn.selected;
    if (btn.selected) {
        [self keyboardHide];
    }
}
#pragma mark ====== 表情按钮 ======
- (void)emojiBtn:(UIButton *)btn {
    self.moreClick = NO;
    self.voiceBtn.selected = NO;
    self.tapVoiceBtn.hidden = YES;
    if (self.emojiClick == NO) {
        self.emojiClick = YES;
        [self.textView resignFirstResponder];
        [self.moreView removeFromSuperview];
        self.moreView = nil;
        [self addSubview:self.emojiView];
        [UIView animateWithDuration:0.25 animations:^{
            self.emojiView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight );
            self.frame = CGRectMake(0, K_Height  - self.backView.height - bottomHeight - TabbarSafeBottomMargin, K_Width, self.backView.height + bottomHeight);
            [self changeTableViewFrame];
        }];
    } else {
        [self.textView becomeFirstResponder];
    }
    [self setBtnsStates];
}

-(void)setBtnsStates {
    self.emojiBtn.selected = self.emojiClick;
    self.moreBtn.selected = self.moreClick;
}

#pragma mark ====== 加号按钮 ======
- (void)moreBtn:(UIButton *)btn {
    self.emojiClick = NO; //主要是设置表情按钮为未点击状态
    self.voiceBtn.selected = NO;
    self.tapVoiceBtn.hidden = YES;
    if (self.moreClick == NO) {
        self.moreClick = YES;
        //回收键盘
        [self.textView resignFirstResponder];
        [self.emojiView removeFromSuperview];
        self.emojiView = nil;
        [self addSubview:self.moreView];
        //改变更多、self的frame
        [UIView animateWithDuration:0.25 animations:^{
            self.moreView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height  - self.backView.height - bottomHeight - TabbarSafeBottomMargin , K_Width, self.backView.height + bottomHeight);
            [self changeTableViewFrame];
        }];
    } else { //再次点击更多按钮
        //键盘弹起
        [self.textView becomeFirstResponder];
    }
     [self setBtnsStates];
}
#pragma - mark tapVoiceBtnAction

-(void)beginRecordVoice:(UIButton *)sender{
    [self.recorder startRecord];
    sender.backgroundColor = UIColorFromRGB(0x333333);
}
-(void)endRecordVoice:(UIButton *)sender{
    [self.recorder completeRecord];
    sender.backgroundColor = UIColorFromRGB(0xdddddd);
}
-(void)cancelRecordVoice:(UIButton *)sender{
    [self.recorder cancelRecord];
    sender.backgroundColor = UIColorFromRGB(0xdddddd);
}
-(void)remindDragExit:(UIButton *)sender{
    [ChatRecordVoiceHUD showWCancel];
    sender.backgroundColor = UIColorFromRGB(0xdddddd);
}
-(void)remindDragEnter:(UIButton *)sender{
    [ChatRecordVoiceHUD showRecording];
    sender.backgroundColor = UIColorFromRGB(0x333333);
}

#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {
    //当输入框大小改变时，改变backView的frame
    self.backView.frame = CGRectMake(0, 0, K_Width, height + (viewMargin * 2));
    if (self.emojiBtn.selected) {
          self.frame = CGRectMake(0, K_Height - self.backView.height - bottomHeight - TabbarSafeBottomMargin , K_Width, self.backView.height + bottomHeight);
    }else{
          self.frame = CGRectMake(0, K_Height - self.backView.height - _keyboardHeight , K_Width, self.backView.height);
    }
  

    [self changeTableViewFrame];
}

#pragma mark ====== 点击空白处，键盘收起时，移动self至底部 ======
- (void)keyboardHide {
    //收起键盘
    [self.textView resignFirstResponder];
    [self removeBottomViewFromSupview];
    [UIView animateWithDuration:0.25 animations:^{
        //设置self的frame到最底部
        self.frame = CGRectMake(0, K_Height - self.backView.height - TabbarSafeBottomMargin, K_Width, self.backView.height);
        [self changeTableViewFrame];
    }];
    [self setBtnsStates];
}

#pragma mark ====== 键盘将要出现 ======
- (void)keyboardWillShow:(NSNotification *)notification {
    [self removeBottomViewFromSupview];
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘的高度
    self.keyboardHeight = endFrame.size.height;
    
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        self.frame = CGRectMake(0, endFrame.origin.y - self.backView.height , K_Width, self.height);
        [self changeTableViewFrame];
    } completion:nil];
    [self setBtnsStates];
}

#pragma mark ====== 键盘将要消失 ======
- (void)keyboardWillHide:(NSNotification *)notification {
    //如果是弹出了底部视图时
    if (self.moreClick || self.emojiClick) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, K_Height - self.backView.height - TabbarSafeBottomMargin, K_Width, self.backView.height);
        [self changeTableViewFrame];
    }];
    [self setBtnsStates];
}

#pragma mark ====== 改变tableView的frame ======
- (void)changeTableViewFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardChangeFrameWithMinY:)]) {
        [self.delegate keyboardChangeFrameWithMinY:self.y];
    }
}

#pragma mark ====== 移除底部视图 ======
- (void)removeBottomViewFromSupview {
    [self.moreView removeFromSuperview];
    [self.emojiView removeFromSuperview];
    self.moreView = nil;
    self.emojiView = nil;
    self.moreClick = NO;
    self.emojiClick = NO;
}

#pragma mark ====== 点击发送按钮 ======
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        [self sendText];
        /*这里返回NO，就代表return键值失效，即页面上按下return，
         不会出现换行，如果为yes，则输入页面会换行*/
        return NO;
    }
    return YES;
}
-(void)sendText{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewContentText:)]) {
        [self.delegate textViewContentText:self.textView.text];
    }
    [self changeFrame:viewHeight];
    self.textView.text = @"";
}

#pragma mark ====== init ======
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        [self addSubview:_backView];
    }
    return _backView;
}

-(UIButton *)tapVoiceBtn{
    if (!_tapVoiceBtn) {
        _tapVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tapVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_tapVoiceBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _tapVoiceBtn.backgroundColor = UIColorFromRGB(0xdddddd);
        _tapVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _tapVoiceBtn.hidden = YES;
        _tapVoiceBtn.layer.cornerRadius = 4.0;
        _tapVoiceBtn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        _tapVoiceBtn.layer.borderWidth = 0.5;
        [_tapVoiceBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_tapVoiceBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_tapVoiceBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_tapVoiceBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_tapVoiceBtn addTarget:self action:@selector(remindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_tapVoiceBtn addTarget:self action:@selector(remindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:_tapVoiceBtn];
    }
    return _tapVoiceBtn;
}

//语音按钮

-(UIButton *)voiceBtn {
    if (_voiceBtn == nil) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage imageWithFont:ic_voice size:25 color:[UIColor grayColor]];
        UIImage *selectedImage = [UIImage imageWithFont:ic_keyborad size:25 color:[UIColor grayColor]];
        [_voiceBtn setImage:normalImage forState:UIControlStateNormal];
        [_voiceBtn setImage:selectedImage forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(switchVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

//表情按钮
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setBackgroundImage:[UIImage imageWithPathOfName:@"chat_bottom_emotion_nor.png"] forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:[UIImage imageWithPathOfName:@"chat_bottom_emotion_press.png"]  forState:UIControlStateSelected];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_emojiBtn];
    }
    return _emojiBtn;
}

//更多按钮
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setBackgroundImage:[UIImage imageWithPathOfName:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
        [_moreBtn setBackgroundImage:[UIImage imageWithPathOfName:@"chat_bottom_up_press.png"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (ChatTextView *)textView {
    if (!_textView) {
        _textView = [[ChatTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        [_textView textValueDidChanged:^(CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        [self.backView addSubview:_textView];
    }
    return _textView;
}

//更多视图
- (ChatMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[ChatMoreView alloc] init];
        _moreView.frame = CGRectMake(0, K_Height, K_Width, bottomHeight);
        _moreView.delegate = self;
    }
    return _moreView;
}
-(ChatRecordVoice *)recorder{
    if (!_recorder) {
        _recorder = [[ChatRecordVoice alloc] initWithDelegate:self];
    }
    return _recorder;
}
//表情视图
- (ChatEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[ChatEmojiView alloc] init];
        _emojiView.frame = CGRectMake(0, K_Height, K_Width, bottomHeight);
        _emojiView.delegate = self;
    }
    return _emojiView;
}

#pragma mark 表情回调

-(void)emojiViewDidPressDeleteButton:(ChatEmojiView *)emojiView{
    NSString *text = self.textView.text;
    if (text.length <= 0)
        return;
    if (text.length == 1) {
        text = @"";
    } else {
        const unichar hs = [text characterAtIndex:text.length - 2];
        const unichar ls = [text characterAtIndex:text.length - 1];
        if ([ChatEmojiView isEmojisWithHeightChar:hs andLowChar:ls])
            text = [text substringToIndex:text.length - 2];
        else
            text = [text substringToIndex:text.length - 1];
    }
    self.textView.text = text;
    [self.textView textDidChange];
}
-(void)emojiView:(ChatEmojiView *)emojiView didPressFaceValue:(NSString *)face{
    NSString *text = self.textView.text;
    self.textView.text = [text stringByAppendingString:face];
    [self.textView textDidChange];

}

-(void)emojiViewDidPressSendButton:(ChatEmojiView *)emojiView{
     [self sendText];
}

#pragma mark ChatMoreViewDelegate
-(void)chatMoreViewSelectType:(ChatMoreType)type {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardSelectType:)]) {
        [self.delegate keyboardSelectType:type];
    }
   
}
-(void)recorderVoiceFailure {
    
}
-(void)recorderVoiceSuccessWithVoiceData:(NSData *)voiceData path:(NSString *)path duration:(long)duration {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recorderVoiceWithVoiceData:path:duration:)]) {
        [self.delegate recorderVoiceWithVoiceData:voiceData path:path duration:duration];
    }
}

#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
