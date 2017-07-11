#import "CADisplayLink+Ext.h"

@interface _CADisplayLinkTarget : NSObject

@property (nonatomic, copy) CADisplayLinkBlock block;

- (void) displayLinkSelector:(CADisplayLink *)displayLink;

@end

#pragma mark -

@implementation _CADisplayLinkTarget

- (void) displayLinkSelector:(CADisplayLink *)displayLink {
    if (self.block) {
        self.block(displayLink);
    }
}

@end

#pragma mark -

@implementation CADisplayLink(Ext)

+ (instancetype) displayLinkWithBlock:(CADisplayLinkBlock)block {
    _CADisplayLinkTarget *target = [[_CADisplayLinkTarget alloc] init];
    target.block = block;

    return [self displayLinkWithTarget:target selector:@selector(displayLinkSelector:)];
}

@end