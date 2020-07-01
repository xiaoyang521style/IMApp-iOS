//
//  DrawerVisualStateManager.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMDrawerVisualState.h"
typedef NS_ENUM(NSInteger, MMDrawerAnimationType){
    DrawerAnimationTypeNone,
    DrawerAnimationTypeSlide,
    DrawerAnimationTypeSlideAndScale,
    DrawerAnimationTypeSwingingDoor,
    DrawerAnimationTypeParallax,
};

@interface DrawerVisualStateManager : NSObject
@property (nonatomic,assign) MMDrawerAnimationType leftDrawerAnimationType;
@property (nonatomic,assign) MMDrawerAnimationType rightDrawerAnimationType;
+ (DrawerVisualStateManager *)sharedManager;

-(MMDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(MMDrawerSide)drawerSide;
+(void)setCloseGesture:(UIViewController *)controller;
+(void)setOpenGesture:(UIViewController *) controller;
@end
