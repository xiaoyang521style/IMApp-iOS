//
//  Util.m
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "Util.h"

@implementation Util

+(void) dispatchMainAsync:(CallBack) block
{
    dispatch_async(dispatch_get_main_queue(), block);
}
+(void) dispatchMainAfter:(NSTimeInterval) delay callback:(CallBack)callback {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        callback();
    });
}

+ (NSString *)urlEncode:(NSString *)str {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#else
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)str,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
#endif
}

+ (NSDate *) dateOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(NSDate *)defaultValue {
    if ([dict objectForKey:fieldName]) {
        return [dict objectForKey:fieldName];
    } else {
        return defaultValue;
    }
}

+ (BOOL)boolOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(bool)defaultValue {
    if ([dict objectForKey:fieldName]) {
        return [[dict objectForKey:fieldName] boolValue];
    } else {
        return defaultValue;
    }
}
+ (NSString *)stringOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(NSString *)defaultValue {
    NSString * value= dict[fieldName];
    if (value && (![value isEqual:[NSNull null]])) {
        return [dict objectForKey:fieldName];
    } else {
        return defaultValue;
    }
}
+ (NSInteger)intOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(NSInteger)defaultValue {
    if ([dict objectForKey:fieldName]) {
        return [[dict objectForKey:fieldName] integerValue];
    } else {
        return defaultValue;
    }
}
+ (float) floatOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(float)defaultValue {
    if ([dict objectForKey:fieldName]) {
        return [[dict objectForKey:fieldName] floatValue];
    } else {
        return defaultValue;
    }
}
+ (float) doubleOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(double)defaultValue {
    if ([dict objectForKey:fieldName]) {
        return [[dict objectForKey:fieldName] doubleValue];
    } else {
        return defaultValue;
    }
}

+ (NSString *)stringOf:(NSDictionary *)dict fieldNames:(NSArray *)fieldNames {
    for (int i = 0; i < fieldNames.count; i++) {
        NSString *fieldName = [fieldNames objectAtIndex:i];
        if (i == fieldNames.count - 1) {
            return dict[fieldName];
        }
        
        id item = dict[fieldName];
        if (item == nil) return nil;
        if ([[item class] isSubclassOfClass:[NSDictionary class]] == false) {
            return nil;
        }
        dict = (NSDictionary *) item;
    }
    return nil;
}
+ (NSString *)toString:(NSInteger)value {
    return [NSString stringWithFormat:@"%ld", value];
}

+ (CGSize)splitFloat:(NSString *)value token:(NSString *)token {
    if (value.length == 0) return CGSizeMake(-1, -1);
    NSArray *values = [value componentsSeparatedByString:token];
    if (values.count == 1) {
        return CGSizeMake(-1, [values[0] floatValue]);
    } else {
        return CGSizeMake([values[0] floatValue], [values[1] floatValue]);
    }
};


@end
