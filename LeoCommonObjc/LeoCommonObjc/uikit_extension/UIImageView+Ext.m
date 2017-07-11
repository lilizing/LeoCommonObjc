#import "UIImageView+Ext.h"
#import "UIImage+Ext.h"
#import "NSObject+Ext.h"
#import "UIColor+Ext.h"

@interface UIImageView(Ext_Private)

@property (nonatomic, strong) NSString *asyncSetImageWithName;
@property (nonatomic, strong) NSString *asyncSetHighlightedImageWithName;

@end

@implementation UIImageView(Ext_Private)

@dynamic asyncSetImageWithName;
- (NSString *) asyncSetImageWithName {
    return GET_ASSOCIATED_OBJ();
}
- (void) setAsyncSetImageWithName:(NSString *)asyncSetImageWithName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(asyncSetImageWithName);
}

@dynamic asyncSetHighlightedImageWithName;
- (NSInteger) asyncSetHighlightedImageWithName {
    return ((NSNumber *)GET_ASSOCIATED_OBJ()).integerValue;
}
- (void) setAsyncSetHighlightedImageWithName:(NSString *)asyncSetHighlightedImageWithName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(asyncSetHighlightedImageWithName);
}

@end

#pragma mark -

@implementation UIImageView(Ext)

- (void) roundImageView {
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0;
}

- (void) roundImageViewWithBorder {
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.layer.borderColor = [UIColor seperatorColor].CGColor;
}

- (void) asyncSetImageWithName:(NSString *)imageName {
    self.asyncSetImageWithName = imageName;

    [UIImage imageNamed:imageName completion:^(UIImage *image) {
        if ([imageName isEqualToString:self.asyncSetImageWithName] ||
            (0 == imageName.length && 0 == self.asyncSetImageWithName.length)) {
            self.image = image;
        }
    }];
}

- (void) asyncSetHighlightedImageWithName:(NSString *)imageName {
    self.asyncSetHighlightedImageWithName = imageName;

    [UIImage imageNamed:imageName completion:^(UIImage *image) {
        if ([imageName isEqualToString:self.asyncSetHighlightedImageWithName] ||
            0 == imageName.length && 0 == self.asyncSetHighlightedImageWithName.length) {
            self.highlightedImage = image;
        }
    }];
}

@end
