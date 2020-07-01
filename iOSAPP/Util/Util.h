//
//  Util.h
//  iOSAPP
//
//  Created by 赵阳 on 2018/3/13.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallBack)();
@interface Util : NSObject
+(void) dispatchMainAsync:(CallBack) block;
+(void) dispatchMainAfter:(NSTimeInterval) delay callback:(CallBack)callback;
+ (NSString *)urlEncode:(NSString *)str;
+ (BOOL)boolOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(bool)defaultValue ;
+ (NSString *)stringOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(NSString *)defaultValue;
+ (NSInteger)intOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(NSInteger)defaultValue;
+ (float) floatOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(float)defaultValue;
+ (float) doubleOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(double)defaultValue;
+ (NSString *)stringOf:(NSDictionary *)dict fieldNames:(NSArray *)fieldNames;
+ (NSString *)toString:(NSInteger)value;
+ (CGSize)splitFloat:(NSString *)value token:(NSString *)token;
+ (NSDate *) dateOf:(NSDictionary *)dict fieldName:(NSString *)fieldName defaultValue:(NSDate *)defaultValue;

@end
