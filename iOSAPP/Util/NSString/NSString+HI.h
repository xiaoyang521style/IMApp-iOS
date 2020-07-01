//
//  NSString+YMUtilities.h
//  yiqihi.com
//
//  Created by zhangjie on 14-6-20.
//  Copyright (c) 2014年 yiqihi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Consts.h"

@interface NSString (HI)

- (BOOL)isValidateMobile;

- (BOOL)isEmail;

- (BOOL)isOnlyCharAndNumber;

- (BOOL)isCharOrNumber;

- (BOOL)isOnlyNumber;

-(int) indexOf:(NSString *)text;

+ (NSString *)fromInt:(int)value;
+ (NSString *)fromDouble:(double)value;


+ (NSString*)icon:(HIFont)value;

+(NSString*) iconWith:(NSString*)hex;

- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex;

+(int) compareVersion:(NSString *)from to:(NSString*) to;

+(NSDictionary *)parseMailto:(NSString*)value;

+ (NSString *)urlDecode:(NSString*)uri;

+(BOOL) isEmpty:(NSString *)value;

@end


@interface NSString (YMDate)

+ (NSString *)currentDate;

+ (NSString *)dateWithNumber:(NSNumber *)number withFormat:(NSString *)format;

+ (NSString *)dateWithSting:(NSString *)timer withFormat:(NSString *)format;

+ (NSString *)dateWithDate:(NSDate *)timer withFormat:(NSString *)format;

+ (NSString *)currentDateMillisecond:(NSDate *)date;
@end

@interface NSString (Money)

+ (NSString *)RMBWithNumber:(NSNumber *)number;

+ (NSString *)RMBWithFloat:(double)value;

+ (NSString *)RMBWithString:(NSString *)value;

@end

@interface NSString (NotNil)

+ (NSString *)NotNilString:(NSString *)str;

@end


@interface NSString (LeftHMS)

+ (NSString *)LeftHMSString:(NSNumber *)number;

@end

@interface NSString (ReplaceByStar)

- (NSString *)replaceStrByStar;

@end

@interface NSString (SQLClean)

- (NSString *)sqlStringClean;

- (NSString *)sqlStringRevert;

@end

@interface NSString (ChatCommand)

- (BOOL)isChatCommand;

@end

