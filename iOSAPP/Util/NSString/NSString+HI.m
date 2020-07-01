//
//  NSString+YMUtilities.m
//  yiqihi.com
//
//  Copyright (c) 2014年 yiqihi.com. All rights reserved.

#import "NSString+HI.h"
#import "NSData+AES256.h"

@implementation NSString (HI)

+ (NSString *)urlDecode:(NSString*)uri
{
    NSString *result = [uri stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

+(NSDictionary *) parseMailto:(NSString *)value{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    value = [value substringFromIndex:7];
    NSArray *array = [value componentsSeparatedByString:@"?"];
    NSString *addr = [array objectAtIndex:0];
    [dict setObject:[addr copy] forKey:@"address"];
    if (array.count==0) return dict;
    value = [array objectAtIndex:1];
    array = [value componentsSeparatedByString:@"&"];
    for( int i=0;i<array.count;i++){
        NSString * v=[array objectAtIndex:i];
        NSArray * values= [v componentsSeparatedByString:@"="];
        if (values.count!=2) continue;
        [dict setObject:[values[1] copy] forKey:[values[0] copy]];
    }
    return dict;
}

+(int) compareVersion:(NSString *)from to:(NSString*) to{
    double fromV=[from doubleValue];
    double toV=[to doubleValue];
    if (fromV>toV){
        return 1;
    }else if (fromV<toV){
        return -1;
    }else{
        return 0;
    }
}


+ (NSString*)icon:(HIFont)value
{
    return [NSString stringWithFormat:@"%C", (unichar)value];
}

+(NSString*) iconWith:(NSString*)hex{
    unsigned long v=strtoul([hex UTF8String],0,16);
    return [NSString stringWithFormat:@"%C", (unichar)v];
}

-(int) indexOf:(NSString *)text
{
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return (int)range.location;
    } else {
            return -1;
    }
}
- (BOOL)isValidateMobile {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}


- (BOOL)isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isOnlyCharAndNumber {
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"] invertedSet];
    NSRange foundRange = [self rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location != NSNotFound) {
        return NO;
    }
    return YES;
}

- (BOOL)isOnlyNumber {
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSRange foundRange = [self rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location != NSNotFound) {
        return NO;
    }
    return YES;
}

- (BOOL)isCharOrNumber {
    NSString *string = @"^[A-Za-z0-9]+$";
    NSPredicate *answer = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    return [answer evaluateWithObject:self];
}

+ (NSString *)fromInt:(int)value {
    return [NSString stringWithFormat:@"%d", value];
}

+ (NSString *)fromDouble:(double)value{
    NSNumber *num = [NSNumber numberWithDouble:value];
    return [num stringValue];
}


- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex
{
    if ([self length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [self length] withString:padString startingAtIndex:padIndex] stringByAppendingString:self];
    else
        return [self copy];
}


+(BOOL) isEmpty:(NSString*)value{
    if([value isEqual:[NSNull null]]) return TRUE;
    if (!value || value.length == 0) return TRUE;
    return FALSE;
}

@end

@implementation NSString (YMStringLength)

- (NSInteger)stringLength {
    NSInteger length = 0;
    for (int i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (character <= 128) {
            length++;
        } else {
            length += 2;
        }
    }
    return length;
}
@end


@implementation NSString (YMDate)

+ (NSString *)currentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)currentDateMillisecond:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)dateWithNumber:(NSNumber *)number withFormat:(NSString *)format {
    if (number == nil || number.integerValue == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.longValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:usLocale];
    NSString *result = [NSString NotNilString:[dateFormatter stringFromDate:date]];
    return result;
}

+ (NSString *)dateWithSting:(NSString *)timer withFormat:(NSString *)format {
    if (timer == nil || timer.integerValue == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timer.longLongValue / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:usLocale];
    NSString *result = [NSString NotNilString:[dateFormatter stringFromDate:date]];
    return result;
}

+ (NSString *)dateWithDate:(NSDate *)timer withFormat:(NSString *)format {
    if (timer == nil) {
        return @"";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:usLocale];
    NSString *result = [NSString NotNilString:[dateFormatter stringFromDate:timer]];
    return result;
}
@end

@implementation NSString (Money)

+ (NSString *)RMBWithNumber:(NSNumber *)number {
    NSString *tmp = (number.stringValue.length <= 0) ? @"0" : number.stringValue;
    NSString *result = [NSString RMBWithString:tmp];
    return result;
}

+ (NSString *)RMBWithFloat:(double)value {
    NSString *result = [NSString stringWithFormat:@"¥%.2f", value];
    return result;
}

+ (NSString *)RMBWithString:(NSString *)value {
    NSString *tmp = (value == nil) ? @"" : value;
    NSString *result = [NSString stringWithFormat:@"¥%@", tmp];
    return result;
}

+ (NSString *)changeFloat:(NSString *)stringFloat {
    NSString *returnString = @"0";
    if (!stringFloat || stringFloat.length <= 0) {
        return returnString;
    }

    NSArray *array = [stringFloat componentsSeparatedByString:@"."];
    NSUInteger deleteLength = 0;
    if (array.count > 0) {
        NSString *decimalString = [array objectAtIndex:1];
        const char *floatChars = [decimalString UTF8String];
        for (int i = [decimalString length] - 1; i >= 0; i--) {
            if (floatChars[i] == '0') {
                deleteLength++;
            } else {
                break;
            }
        }
        if (deleteLength == decimalString.length) {
            deleteLength++;
        }
    }

    returnString = [stringFloat substringWithRange:NSMakeRange(0, stringFloat.length - deleteLength)];
    return returnString;
}

@end

@implementation NSString (NotNil)
+ (NSString *)NotNilString:(NSString *)str {
    return (str == nil) ? @"" : str;
}

@end


@implementation NSString (LeftHMS)
+ (NSString *)LeftHMSString:(NSNumber *)number {
    NSInteger time = number.intValue;
    int s = time % 60;
    int m = (time / 60) % 60;
    int h = time / 3600;
    NSString *f = HI_TEXT(@"%d小时%d分%d秒", @"");
    NSString *result = [NSString stringWithFormat:f, h, m, s];
    return result;
}

@end


@implementation NSString (ReplaceByStar)

- (NSString *)replaceStrByStar {
    NSRange range = NSMakeRange(3, 4);
    NSString *resultStr;
    if (self.length > 8) {
        resultStr = [self stringByReplacingCharactersInRange:range withString:@"****"];
        return resultStr;
    }
    return nil;
}

@end

@implementation NSString (SQLClean)

- (NSString *)sqlStringClean {
    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"\"" withString:@"/'"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    newStr = [newStr stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    return newStr;
}

- (NSString *)sqlStringRevert {
    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/'" withString:@"\""];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/(" withString:@"("];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/)" withString:@")"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/[" withString:@"["];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/]" withString:@"]"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/%" withString:@"%"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/&" withString:@"&"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"/_" withString:@"_"];
    return newStr;
}

@end

@implementation NSString (ChatCommand)

- (BOOL)isChatCommand {
    if (![self hasPrefix:@"add"] && ![self hasPrefix:@"Add"] &&
            ![self hasPrefix:@"out"] && ![self hasPrefix:@"Out"] &&
            ![self hasPrefix:@"to"] && ![self hasPrefix:@"To"] &&
            ![self hasPrefix:@"bye"] && ![self hasPrefix:@"Bye"] &&
            ![self hasPrefix:@"req"] && ![self hasPrefix:@"Req"] &&
            ![self hasPrefix:@"link"] && ![self hasPrefix:@"Link"] &&
            ![self hasPrefix:@"me"] && ![self hasPrefix:@"Me"] &&
            ![self hasPrefix:@"open"] && ![self hasPrefix:@"Open"] &&
            ![self hasPrefix:@"close"] && ![self hasPrefix:@"Close"] &&
            ![self hasPrefix:@"price"] && ![self hasPrefix:@"Price"] &&
            ![self hasPrefix:@"pay"] && ![self hasPrefix:@"Pay"] &&
            ![self hasPrefix:@"test"] && ![self hasPrefix:@"Test"]
            )
        return NO;
    return YES;
}

@end
