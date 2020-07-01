//
//  DrawerController.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
@interface DrawerRootController :UIViewController
-(void)contentSizeDidChange:(NSString*)size;

-(void)centerVC:(UIViewController *)controller;



@end
