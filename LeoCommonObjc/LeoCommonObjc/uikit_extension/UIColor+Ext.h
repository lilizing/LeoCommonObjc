#import <UIKit/UIKit.h>

@interface UIColor (Ext)

+ (UIColor *)randomColor;

+ (instancetype)seperatorColor;

+ (UIColor *)colorWithCSSString_ARGB:(NSString *)cssColorString;

+ (UIColor *)colorWithCSSString_RGB:(NSString *)rgbString alpha:(float)alpha;

- (NSString *)CSSColorString_ARGB;

@end
