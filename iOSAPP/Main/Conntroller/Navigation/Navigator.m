//
//  Navigator.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/3/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "Navigator.h"
#import "NavigationController.h"
#import "ChatMessageTableViewController.h"
#import "ScanViewController.h"
static Navigator *navigator_instance;
static dispatch_once_t navigator_once;
@interface Navigator ()

@end

@implementation Navigator
+(Navigator *)get{
    dispatch_once(&navigator_once, ^{
        navigator_instance = [[Navigator alloc] init];
    });
    return navigator_instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}
-(void)pushVC:(UIViewController *)controller {
    [self pushViewController:controller animated:YES];
}

-(void)presentVC:(UIViewController *)controller  {
    [self presentViewController:controller animated:YES completion:nil] ;
}
-(void)presentLoginVC{
    LoginController *loginVC = [[LoginController alloc]init];
    NavigationController *navigationVC = [[NavigationController alloc]initWithRootViewController:loginVC];
    [self presentVC:navigationVC];
}

-(void)showChatControllerWithUser:(User *)user roomId:(NSString *)roomId{
    ChatMessageTableViewController *chatVC = [[ ChatMessageTableViewController alloc]initWithUser:user roomId:roomId];
    [self pushVC:chatVC];
}

-(void)showFindContacts {
    FindContactsController *controller = [[FindContactsController alloc]init];
    [self pushVC:controller];
}
-(void)showScanVC {
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    scanVC.isVideoZoom = YES;
    [self pushVC:scanVC];
}
@end
