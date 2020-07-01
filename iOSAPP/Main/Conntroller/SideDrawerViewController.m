//
//  SideDrawerViewController.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#define HeaderH 150
#define TableViewBackgroundColor [UIColor colorWithRed:110.0/255.0 green:113.0/255.0 blue:115.0/255.0 alpha:1.0]
#define BarColor [UIColor colorWithRed:161.0/255.0 green:164.0/255.0 blue:166.0/255.0 alpha:1.0]
#define TitleColor [UIColor colorWithRed:55.0/255.0 green:70.0/255.0 blue:77.0/255.0 alpha:1.0]
#import "SideDrawerViewController.h"
#import "NavigationController.h"
#import "CenterController.h"
#import "LogoView.h"

@interface SideDrawerViewController ()
@property(nonatomic, assign)BOOL isCloseDrawerGesture;
@end

@implementation SideDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HeaderH, self.view.bounds.size.width, self.view.bounds.size.height - 140) style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _headerView = [[LeftDrawerHeaderView alloc]init];
    _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, HeaderH);
    [_headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_headerView];
    
    [self.tableView setBackgroundColor:TableViewBackgroundColor];
    [self.headerView setBackgroundColor:TableViewBackgroundColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:BarColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:BarColor];
    }
    NSDictionary *navBarTitleDict;
    UIColor * titleColor = TitleColor;
    
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
    CGSize logoSize = CGSizeMake(58, 62);
    LogoView * logo = [[LogoView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tableView.bounds)-logoSize.width/2.0,
                                                                     -logoSize.height-logoSize.height/4.0,
                                                                     logoSize.width,
                                                                     logoSize.height)];
    [logo setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.tableView addSubview:logo];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.mm_drawerController.openDrawerGestureModeMask ^=  MMOpenDrawerGestureModePanningCenterView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MMSideDrawerSectionHeaderView * headerView;
    headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 56.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}
-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    switch (indexPath.section) {
            case DrawerSectionViewSelection:
            if(indexPath.row == 0){
                [cell.textLabel setText:@"Quick View Change"];
            }
            else {
                [cell.textLabel setText:@"Full View Change"];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
            case DrawerSectionDrawerWidth:{
                //Implement in Subclass
                break;
            }
            case DrawerSectionShadowToggle:{
                [cell.textLabel setText:@"Show Shadow"];
                if(self.mm_drawerController.showsShadow)
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                else
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                break;
            }
            case DrawerSectionOpenDrawerGestures:{
                switch (indexPath.row) {
                        case 0:
                        [cell.textLabel setText:@"Pan Nav Bar"];
                        if((self.mm_drawerController.openDrawerGestureModeMask&MMOpenDrawerGestureModePanningNavigationBar)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 1:
                        [cell.textLabel setText:@"Pan Center View"];
                        if((self.mm_drawerController.openDrawerGestureModeMask&MMOpenDrawerGestureModePanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 2:
                        [cell.textLabel setText:@"Bezel Pan Center View"];
                        if((self.mm_drawerController.openDrawerGestureModeMask&MMOpenDrawerGestureModeBezelPanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                    default:
                        break;
                }
                break;
            }
            case DrawerSectionCloseDrawerGestures:{
                switch (indexPath.row) {
                        case 0:
                        [cell.textLabel setText:@"Pan Nav Bar"];
                        if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModePanningNavigationBar)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 1:
                        [cell.textLabel setText:@"Pan Center View"];
                        if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModePanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 2:
                        [cell.textLabel setText:@"Bezel Pan Center View"];
                        if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModeBezelPanningCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 3:
                        [cell.textLabel setText:@"Tap Nav Bar"];
                        if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModeTapNavigationBar)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 4:
                        [cell.textLabel setText:@"Tap Center View"];
                        if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModeTapCenterView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 5:
                        [cell.textLabel setText:@"Pan Drawer View"];
                        if((self.mm_drawerController.closeDrawerGestureModeMask&MMCloseDrawerGestureModePanningDrawerView)>0)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                    default:
                        break;
                }
                break;
            }
            case DrawerSectionCenterHiddenInteraction:{
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                switch (indexPath.row) {
                        case 0:
                        [cell.textLabel setText:@"None"];
                        if(self.mm_drawerController.centerHiddenInteractionMode == MMDrawerOpenCenterInteractionModeNone)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 1:
                        [cell.textLabel setText:@"Full"];
                        if(self.mm_drawerController.centerHiddenInteractionMode == MMDrawerOpenCenterInteractionModeFull)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        case 2:
                        [cell.textLabel setText:@"Nav Bar Only"];
                        if(self.mm_drawerController.centerHiddenInteractionMode == MMDrawerOpenCenterInteractionModeNavigationBarOnly)
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                        else
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                        break;
                        
                    default:
                        break;
                }
                break;
            }
            case DrawerSectionStretchDrawer:{
                [cell.textLabel setText:@"Stretch Drawer"];
                if(self.mm_drawerController.shouldStretchDrawer)
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                else
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                break;
            }
        default:
            break;
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
            case DrawerSectionViewSelection:
            return @"New Center View";
            case DrawerSectionDrawerWidth:
            return @"Drawer Width";
            case DrawerSectionShadowToggle:
            return @"Shadow";
            case DrawerSectionOpenDrawerGestures:
            return @"Drawer Open Gestures";
            case DrawerSectionCloseDrawerGestures:
            return @"Drawer Close Gestures";
            case DrawerSectionCenterHiddenInteraction:
            return @"Open Center Interaction Mode";
            case DrawerSectionStretchDrawer:
            return @"Strech Drawer";
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CenterController *centerVC = [[CenterController alloc]init];
    [self centerVC:centerVC];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
