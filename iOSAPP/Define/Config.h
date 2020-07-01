//
//  Config.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/12.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define FONT_NAME @"iconfont"

#define LoginAccount @"LoginAccount"

#define SocketPort @"socketPort"
#define SocketIP @"socketIP"

//#define DebugRestServer @"";

#define DEVIVETOKEN  @"deviceToken"
//配置模式
#define DEBUGMODE YES

#define DEBUGVIEW 8

#define WEBSERVERPORT (20136)

#define WEBSERVER (20136)


#define HI_TEXT(text, comment) ([[NSBundle mainBundle] localizedStringForKey:(text) value:(text) table:nil])

#define USERID @"userId"

//通讯录更新
#define NOTIFICATION_RELOADCONTACT @"reload_contacts"

//新消息
#define NOTIFICATION_NEWMESSAGE @"new_message"

//刷新会话列表
#define NOTIFICATION_RELOADSESSION @"reload_session"

//好友搜索结果
#define NOTIFICATION_SearchFriendsResult @"searchFriendsResult"

#define NOTIFICATION_SOCK_STATUS @"sock_status"
#endif /* Config_h */
