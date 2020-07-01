

typedef NS_ENUM(NSUInteger, HIFont)
{
    //聊天语音
    ic_arrowback       = 0xe622,
    ic_album           = 0xe611,
    ic_voice           = 0xe7e2,
    ic_keyborad        = 0xe7db,
    ic_colse           = 0xe623,
    ic_arrow_left      = 0xe624,
    ic_add             = 0xe616,
    ic_men             = 0xe626,
    ic_women           = 0xe625
};

typedef NS_ENUM(NSUInteger, ToolBarMode)
{
    NoneToolBar = 0,
    NormalToolBar = 1,
    SearchToolBar = 2,
    SegmentToolBar= 3,
    MenuToolBar   = 4
};

typedef NS_ENUM(NSUInteger, PageHeadMode)
{
    NoneHead = 0,
    CarouselHead = 1,
    SortMenuHead = 2
};

typedef NS_ENUM(NSUInteger, PageInjectMode)
{
    NoneInject = 0,
    IsInjected = 1,
    HasInject = 2
};

extern UIColor *Color_Face5;
extern NSString * startupOption;
extern NSMutableArray * RandomColors;
extern int  DebugSocketPort;
extern NSString * DebugAppServer;
extern NSString * DebugSocketServer;
extern NSString * DebugRestServer;
extern NSString * DebugWebServer;
extern NSString * RestServer;
extern NSString * SocketServer;
extern BOOL EnableSSL;
extern NSMutableDictionary * BizTypes;

#define  CYLTagTitleFont [UIFont systemFontOfSize:16]
/*
 * View helper macros
 */
#define VIEW_WIDTH(view) (view.bounds.size.width)
#define VIEW_HEIGHT(view) (view.bounds.size.height)

#define VIEW_LEFT(view) (view.frame.origin.x)
#define VIEW_TOP(view) (view.frame.origin.y)
#define VIEW_BOTTOM(view) (VIEW_HEIGHT(view) + VIEW_TOP(view))
#define VIEW_RIGHT(view)  (VIEW_LEFT(view) + VIEW_WIDTH(view))

#define TAG_HIDENAVIGATION 1206

#define SET_VIEW_HEIGHT(view, height) \
view.frame = CGRectMake(VIEW_LEFT(view), VIEW_TOP(view), VIEW_WIDTH(view), (height));

#define SET_VIEW_WIDTH(view, width) \
view.frame = CGRectMake(VIEW_LEFT(view), VIEW_TOP(view), (width), VIEW_HEIGHT(view));

#define SET_VIEW_LEFT(view, left) \
view.frame = CGRectMake((left), VIEW_TOP(view), VIEW_WIDTH(view), VIEW_HEIGHT(view));

#define SET_VIEW_TOP(view, top) \
view.frame = CGRectMake(VIEW_LEFT(view), (top), VIEW_WIDTH(view), VIEW_HEIGHT(view));

#define SET_VIEW_CENTERY(view, centerY) \
view.center = CGPointMake(view.center.x, (centerY))

#define SET_VIEW_CENTERX(view, centerX) \
view.center = CGPointMake((centerX), view.center.y)

#ifndef ConstantVaribles_h
#define ConstantVaribles_h

typedef NS_ENUM(NSInteger, ModalTransitionType) {
    ModalTransitionTypeNone = 9999,
    ModalTransitionTypePopup,
    ModalTransitionTypeBottomSliding
};


#endif

#import "metamacros.h"

// Color helpers
#define RGBCOLOR(r,g,b) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1])
#define RGBACOLOR(r,g,b,a) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)])
#define RGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])





@interface Consts : NSObject

@end
