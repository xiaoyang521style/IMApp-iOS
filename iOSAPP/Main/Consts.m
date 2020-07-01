#import "Consts.h"
#import "RealmTable.h"
#import "NSString+HI.h"


NSString * startupOption;
NSMutableArray * RandomColors;
NSString * DebugAppServer;
NSString * DebugSocketServer;
NSString * SocketServer;
NSString * DebugRestServer;
NSString * RestServer;
NSString * DebugWebServer;
int DebugSocketPort;



@implementation Consts

+ (void)initialize {
    [super initialize];

    
    startupOption=nil;
   
    /*
     browser---->http    --->webServer  --->appserver
     client ---->http    --->restServer --->appserver
     chat   ---->socket  --->socketServer
     */
   
  DebugSocketServer = @"localhost";
  // DebugSocketServer = @"192.168.30.188";
 //      DebugSocketServer = @"192.168.123.9";
    DebugSocketPort = 20001 ;

    
     DebugRestServer= @"http://localhost:8080/AppService/appservice";
 //   DebugRestServer= @"http://192.168.30.188:8080/AppService/appservice";
//   DebugRestServer= @"http://192.168.123.9:8080/AppService/appservice";
     RestServer= @"http://47.105.50.16:8080/AppService/appservice";
    
    DebugWebServer= [NSString stringWithFormat:@"localhost:%d",WEBSERVERPORT];//生产环境
}


@end
