#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor*) colorWithHex: (NSUInteger)hex ;
+ (UIColor*) colorWithCSS: (NSString*)css ;

+ (UIColor *)colorWith:(int)r green:(int)g blue:(int)b;
+ (UIColor *)colorWith:(int)r green:(int)g blue:(int)b a:(CGFloat)a;

+ (BOOL)isColorClear:(UIColor *)color;
+ (BOOL)isColorDark:(UIColor *)color;
+ (BOOL)isColorLight:(UIColor *)color;
@end
