#import "CALayer+Ext.h"
#import "UIImage+Ext.h"
#import "NSObject+Ext.h"

@interface CALayer(Ext_Private)

@property (nonatomic, strong) NSString *asyncSetImageWithName;

@end

@implementation CALayer(Ext_Private)

@dynamic asyncSetImageWithName;
- (NSString *) asyncSetImageWithName {
    return GET_ASSOCIATED_OBJ();
}
- (void) setAsyncSetImageWithName:(NSString *)asyncSetImageWithName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(asyncSetImageWithName);
}

@end

#pragma mark -

@implementation CALayer(Ext)

- (void) asyncSetImageWithName:(NSString *)imageName {
    self.asyncSetImageWithName = imageName;

    [UIImage imageNamed:imageName completion:^(UIImage *image) {
        if ([imageName isEqualToString:self.asyncSetImageWithName]) {
            self.contents = (id)image.CGImage;
        }
    }];
}

@end
