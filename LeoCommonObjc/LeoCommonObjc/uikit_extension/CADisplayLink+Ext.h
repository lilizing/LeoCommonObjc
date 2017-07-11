#import <QuartzCore/QuartzCore.h>

typedef void (^CADisplayLinkBlock)(CADisplayLink *sender);

@interface CADisplayLink(Ext)

+ (instancetype) displayLinkWithBlock:(CADisplayLinkBlock)block;

@end