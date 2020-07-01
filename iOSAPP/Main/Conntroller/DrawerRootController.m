//
//  DrawerController.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "DrawerRootController.h"
#import "NavigationController.h"

@interface DrawerRootController ()

@end

@implementation DrawerRootController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(contentSizeDidChangeNotification:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}
-(void)contentSizeDidChangeNotification:(NSNotification*)notification{
    [self contentSizeDidChange:notification.userInfo[UIContentSizeCategoryNewValueKey]];
}

-(void)contentSizeDidChange:(NSString *)size{
    //Implement in subclass
}


-(void)centerVC:(UIViewController *)controller {
    NavigationController * nav = [[NavigationController alloc] initWithRootViewController:controller];
    [self.mm_drawerController
     setCenterViewController:nav
     withCloseAnimation:YES completion:nil];
}

@end
