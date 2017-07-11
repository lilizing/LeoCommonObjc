#import "UIColor+Ext.h"
#import "NSString+Ext.h"

@implementation UIColor(Ext)

+ (UIColor *)randomColor{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        srandom((unsigned)time(NULL));
    });
    
    return [UIColor colorWithRed:(CGFloat)(random()%256)/255
                           green:(CGFloat)(random()%256)/255
                            blue:(CGFloat)(random()%256)/255
                           alpha:1.];
}

+ (instancetype) seperatorColor
{
    return [UIColor colorWithCSSString_ARGB:@"#ffdcdcdc"];
}

+ (UIColor *)colorWithCSSString_ARGB:(NSString *)cssColorString {
    UIColor *result = nil;
    
    if (9 != [cssColorString length] || '#' != [cssColorString characterAtIndex:0]) {
        return result;
    }
    
    CGFloat alpha = [[cssColorString substringWithRange:NSMakeRange(1, 2)] hexInteger]/255.f;
    CGFloat red   = [[cssColorString substringWithRange:NSMakeRange(3, 2)] hexInteger]/255.f;
    CGFloat green = [[cssColorString substringWithRange:NSMakeRange(5, 2)] hexInteger]/255.f;
    CGFloat blue  = [[cssColorString substringWithRange:NSMakeRange(7, 2)] hexInteger]/255.f;
    
    result = [self colorWithRed:red green:green blue:blue alpha:alpha];
    
    return result;
}

+ (UIColor *)colorWithCSSString_RGB:(NSString *)cssColorString alpha:(float)alpha {
    UIColor *result = nil;
    
    if (7 != [cssColorString length] || '#' != [cssColorString characterAtIndex:0]) {
        return result;
    }
    
    CGFloat red   = [[cssColorString substringWithRange:NSMakeRange(1, 2)] hexInteger]/255.f;
    CGFloat green = [[cssColorString substringWithRange:NSMakeRange(3, 2)] hexInteger]/255.f;
    CGFloat blue  = [[cssColorString substringWithRange:NSMakeRange(5, 2)] hexInteger]/255.f;
    
    result = [self colorWithRed:red green:green blue:blue alpha:alpha];
    
    return result;
}

- (NSString *)CSSColorString_ARGB {
    const CGFloat *colorComponents = CGColorGetComponents(self.CGColor);
    
    int red   = colorComponents[0] * 255;
    int green = colorComponents[1] * 255;
    int blue  = colorComponents[2] * 255;
    int alpha = colorComponents[3] * 255;
    
    return [NSString stringWithFormat:@"#%.2x%.2x%.2x%.2x", alpha, red, green, blue];
}

@end
