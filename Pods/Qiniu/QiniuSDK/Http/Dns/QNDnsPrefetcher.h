//
//  QNDnsPrefetcher.h
//  QnDNS
//
//  Created by yangsen on 2020/3/26.
//  Copyright © 2020 com.qiniu. All rights reserved.
//

#import "QNTransactionManager.h"
#import "QNDns.h"
#import "QNConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

#define kQNDnsPrefetcher [QNDnsPrefetcher shared]
@interface QNDnsPrefetcher : NSObject

+ (instancetype)shared;

// 无效缓存，会根据inetAddress的host获取缓存列表，并移除inetAddress
- (void)invalidInetAdress:(id <QNInetAddressDelegate>)inetAddress;

/// 根据host从缓存中读取DNS信息
- (NSArray <id <QNInetAddressDelegate> > *)getInetAddressByHost:(NSString *)host;

@end



@interface QNTransactionManager(Dns)

/// 添加加载本地dns事务
- (void)addDnsLocalLoadTransaction;

/// 添加检测并预取dns事务 如果未开启DNS 或 事务队列中存在token对应的事务未处理，则返回NO
- (BOOL)addDnsCheckAndPrefetchTransaction:(QNZone *)currentZone token:(NSString *)token;

/// 设置定时事务：检测已缓存DNS有效情况事务 无效会重新预取
- (void)setDnsCheckWhetherCachedValidTransactionAction;

@end

NS_ASSUME_NONNULL_END
