//
//  ChatMoreView.h
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/31.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatMoreType) {

    /*!
     相册
     */
    ChatMoreTypeAlbum = 1
};


@protocol ChatMoreViewDelegate<NSObject>
-(void)chatMoreViewSelectType:(ChatMoreType) type;
@end

@interface ChatMoreView : UIView
@property(nonatomic, weak)id<ChatMoreViewDelegate>delegate;
@end
