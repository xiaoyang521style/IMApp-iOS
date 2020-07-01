//
//  SessionViewModel.m
//  iOSAPP
//
//  Created by xiaoyang on 2018/5/28.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SessionViewModel.h"
#import "SessionView.h"
#import "SessionController.h"
#import "SessionCell.h"
#import "SessionModel.h"
#import "User.h"
#import "ChatMessageTableViewController.h"
@interface SessionViewModel()<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, strong)SessionController *controller;
@property(nonatomic, strong)SessionView *sessionView;
@property(nonatomic, strong)NSMutableArray *sessions;
@end

@implementation SessionViewModel

-(instancetype)initView:(SessionView *)sessionView controller:(SessionController *)controller {
    if ([super init]) {
        _controller = controller;
        _sessionView = sessionView;
        _sessionView.tableView.delegate = self;
        _sessionView.tableView.dataSource = self;
        NotificationCenterAddObserver(self, @selector(readSessions:), NOTIFICATION_RELOADSESSION, nil);
        [_sessionView.tableView registerClass:[SessionCell class] forCellReuseIdentifier:NSStringFromClass([SessionCell class])];
        for ( NSDictionary *dict in [[RealmTable get]readSessions]) {
            ChatRecord *chatRecord = dict[@"chatRecord"];
            [Context get].unreadMessageCount += [dict[@"unReadCount"] intValue];
            SessionModel *model = [[SessionModel alloc]initWith:chatRecord];
            model.unReadCount = [dict[@"unReadCount"] intValue];
            [self.sessions addObject:model];
        }
        NSSortDescriptor *des1 = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
        NSArray *arr = [self.sessions sortedArrayUsingDescriptors:@[des1]].copy;
        self.sessions = [NSMutableArray arrayWithArray:arr];
    }
    return self;
}

-(void)dealloc {
    NotificationCenterRemoveObserver(self, NOTIFICATION_RELOADSESSION, nil);
}

-(void)readSessions:(NSNotification *)notif{
    
    NSDictionary *dict = notif.object;
   
    ChatRecord *chatRecord = dict[@"chatRecord"];
    SessionModel *newmodel = [[SessionModel alloc]initWith:chatRecord];
    int oldNum = 0;
    SessionModel *oldmodel;
    for (SessionModel *model in self.sessions) {
        if (model.userId == newmodel.userId) {
            if ([dict[@"needUpateReadCount"] boolValue]) {
                if (newmodel.sendUserId!=[Context get].userId) {
                    oldNum = model.unReadCount;
                    [Context get].unreadMessageCount ++;
                    newmodel.unReadCount = oldNum+1;
                }
            }
            oldmodel = model;
        }
    }
    [self.sessions removeObject:oldmodel];
    [self.sessions insertObject:newmodel atIndex:0];
    [self.sessionView.tableView reloadData];
}

-(NSMutableArray *)sessions {
    if (_sessions == nil) {
        _sessions = [NSMutableArray new];
    }
    return _sessions;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SessionCell class]) forIndexPath:indexPath];
    cell.model = self.sessions[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([Context get].unreadMessageCount >= 0) {
            [Context get].unreadMessageCount -= [cell.badgeLabel.text intValue];
    }else{
        [Context get].unreadMessageCount = 0;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cell.badgeLabel.hidden = YES;
    cell.model.unReadCount = 0;
    User *user = [[User alloc]init];
    user.Id = cell.model.userId;
    user.name = cell.model.username;
    user.avatar = cell.model.icon;
    ChatMessageTableViewController *chatVC = [[ChatMessageTableViewController alloc]initWithUser:user roomId:cell.model.roomId];
    [self.controller.navigationController pushViewController:chatVC animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SessionModel *model = self.sessions[indexPath.row];
        NSMutableArray *chatRecords = [[RealmTable get]readChatRecord:model.userId];
        [[MessageBus get].chatRecords removeObjectsInArray:chatRecords];
        [[RealmTable get]removeChatRecords:chatRecords];
        [self.sessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
