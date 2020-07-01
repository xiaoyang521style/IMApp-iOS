//
//  QNConfiguration.m
//  QiniuSDK
//
//  Created by bailong on 15/5/21.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import "QNConfiguration.h"
#import "QNHttpResponseInfo.h"
#import "QNResponseInfo.h"
#import "QNSessionManager.h"
#import "QNUpToken.h"
#import "QNUploadInfoReporter.h"
#import "QNAutoZone.h"

const UInt32 kQNBlockSize = 4 * 1024 * 1024;
const UInt32 kQNDefaultDnsCacheTime = 2 * 60;


@implementation QNConfiguration

+ (instancetype)build:(QNConfigurationBuilderBlock)block {
    QNConfigurationBuilder *builder = [[QNConfigurationBuilder alloc] init];
    block(builder);
    return [[QNConfiguration alloc] initWithBuilder:builder];
}

- (instancetype)initWithBuilder:(QNConfigurationBuilder *)builder {
    if (self = [super init]) {

        _chunkSize = builder.chunkSize;
        _putThreshold = builder.putThreshold;
        _retryMax = builder.retryMax;
        _retryInterval = builder.retryInterval;
        _timeoutInterval = builder.timeoutInterval;

        _recorder = builder.recorder;
        _recorderKeyGen = builder.recorderKeyGen;

        _proxy = builder.proxy;

        _converter = builder.converter;
        
        _zone = builder.zone;

        _useHttps = builder.useHttps;

        _allowBackupHost = builder.allowBackupHost;
        
        _reportConfig = builder.reportConfig;

        _useConcurrentResumeUpload = builder.useConcurrentResumeUpload;
        
        _concurrentTaskCount = builder.concurrentTaskCount;
    }
    return self;
}

@end

@interface QNGlobalConfiguration()
@end
@implementation QNGlobalConfiguration
+ (instancetype)shared{
    static QNGlobalConfiguration *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[QNGlobalConfiguration alloc] init];
        [config setupData];
    });
    return config;
}
- (void)setupData{
    _isDnsOpen = YES;
    _dnscacheDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    _dnsRepreHostNum = 2;
    _dnsCacheTime = kQNDefaultDnsCacheTime;
}
@end

@implementation QNConfigurationBuilder

- (instancetype)init {
    if (self = [super init]) {
        _zone = [[QNAutoZone alloc] init];
        _chunkSize = 2 * 1024 * 1024;
        _putThreshold = 4 * 1024 * 1024;
        _retryMax = 3;
        _timeoutInterval = 60;
        _retryInterval = 0.5;
        _reportConfig = [QNReportConfig sharedInstance];

        _recorder = nil;
        _recorderKeyGen = nil;

        _proxy = nil;
        _converter = nil;

        _useHttps = YES;
        _allowBackupHost = YES;
        _useConcurrentResumeUpload = NO;
        _concurrentTaskCount = 3;
    }
    return self;
}

@end

