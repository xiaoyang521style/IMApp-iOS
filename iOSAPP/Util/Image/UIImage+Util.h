#import <UIKit/UIKit.h>
#import "Consts.h"
#import "UIImage+Util.h"

@interface UIImage (Util)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color havingSize:(CGSize)size;
+ (UIImage*)imageWithIcon:(NSString*)iconCode size:(NSUInteger)size color:(UIColor*)color;
+ (UIImage*)imageWithFont:(HIFont)icon size:(NSUInteger)size color:(UIColor*)color;
+(CGSize)getImageSizeWithURL:(id)imageURL;
+(UIImage *)imageWithPathOfName:(NSString *)imgName;
@end
