#import "UIButton+Ext.h"
#import "NSObject+Ext.h"
#import "UIImage+Ext.h"

@implementation UIButton(Ext)

@dynamic normalStateTitle;
- (NSString *)normalStateTitle {
    return [self titleForState:UIControlStateNormal];
}
- (void) setNormalStateTitle:(NSString *)normalStateTitle{
    BOOL oldEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];

    // disable animations while setting button title
    [self setTitle:normalStateTitle forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:oldEnabled];
}

@dynamic normalStateAttributedTitle;
- (NSAttributedString *) normalStateAttributedTitle {
    return [self attributedTitleForState:UIControlStateNormal];
}
- (void)setNormalStateAttributedTitle:(NSAttributedString *)normalStateAttributedTitle {
    BOOL oldEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];

    // disable animations while setting button title
    [self setAttributedTitle:normalStateAttributedTitle forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:oldEnabled];
}

@dynamic normalStateImage;
- (UIImage *)normalStateImage {
    return [self imageForState:UIControlStateNormal];
}
- (void)setNormalStateImage:(UIImage *)normalStateImage {
    [self setImage:normalStateImage forState:UIControlStateNormal];
}

@dynamic normalStateImageName;
- (NSString *)normalStateImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setNormalStateImageName:(NSString *)normalStateImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(normalStateImageName);

    [self setImage:[UIImage imageNamed:normalStateImageName] forState:UIControlStateNormal];
}

@dynamic disabledStateImage;
- (UIImage *)disabledStateImage {
    return [self imageForState:UIControlStateDisabled];
}
- (void)setDisabledStateImage:(UIImage *)disabledStateImage {
    [self setImage:disabledStateImage forState:UIControlStateDisabled];
}

@dynamic disabledStateImageName;
- (NSString *)disabledStateImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setDisabledStateImageName:(NSString *)disabledStateImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(disabledStateImageName);

    [self setImage:[UIImage imageNamed:disabledStateImageName] forState:UIControlStateDisabled];
}

@dynamic highlightedStateImage;
- (UIImage *)highlightedStateImage {
    return [self imageForState:UIControlStateHighlighted];
}
- (void)setHighlightedStateImage:(UIImage *)highlightedStateImage {
    [self setImage:highlightedStateImage forState:UIControlStateHighlighted];
}

@dynamic highlightedStateImageName;
- (NSString *)highlightedStateImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setHighlightedStateImageName:(NSString *)highlightedStateImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(highlightedStateImageName);

    [self setImage:[UIImage imageNamed:highlightedStateImageName] forState:UIControlStateHighlighted];
}

@dynamic selectedStateImage;
- (UIImage *)selectedStateImage {
    return [self imageForState:UIControlStateSelected];
}
- (void)setSelectedStateImage:(UIImage *)selectedStateImage {
    [self setImage:selectedStateImage forState:UIControlStateSelected];
}

@dynamic selectedStateImageName;
- (NSString *)selectedStateImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setSelectedStateImageName:(NSString *)selectedStateImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(selectedStateImageName);
    
    [self setImage:[UIImage imageNamed:selectedStateImageName] forState:UIControlStateSelected];
}

@dynamic normalStateBackgroundImage;
- (UIImage *)normalStateBackgroundImage {
    return [self backgroundImageForState:UIControlStateNormal];
}
- (void)setNormalStateBackgroundImage:(UIImage *)normalStateBackgroundImage {
    [self setBackgroundImage:normalStateBackgroundImage forState:UIControlStateNormal];
}

@dynamic normalStateBackgroundImageName;
- (NSString *)normalStateBackgroundImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setNormalStateBackgroundImageName:(NSString *)normalStateBackgroundImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(normalStateBackgroundImageName);

    [self setBackgroundImage:[UIImage imageNamed:normalStateBackgroundImageName] forState:UIControlStateNormal];
}

@dynamic disabledStateBackgroundImage;
- (UIImage *)disabledStateBackgroundImage {
    return [self backgroundImageForState:UIControlStateDisabled];
}
- (void)setDisabledStateBackgroundImage:(UIImage *)disabledStateBackgroundImage {
    [self setBackgroundImage:disabledStateBackgroundImage forState:UIControlStateDisabled];
}

@dynamic disabledStateBackgroundImageName;
- (NSString *)disabledStateBackgroundImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setDisabledStateBackgroundImageName:(NSString *)disabledStateBackgroundImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(disabledStateBackgroundImageName);

    [self setBackgroundImage:[UIImage imageNamed:disabledStateBackgroundImageName] forState:UIControlStateDisabled];
}

@dynamic highlightedStateBackgroundImage;
- (UIImage *)highlightedStateBackgroundImage {
    return [self backgroundImageForState:UIControlStateHighlighted];
}
- (void)setHighlightedStateBackgroundImage:(UIImage *)highlightedStateBackgroundImage {
    [self setBackgroundImage:highlightedStateBackgroundImage forState:UIControlStateHighlighted];
}

@dynamic highlightedStateBackgroundImageName;
- (NSString *)highlightedStateBackgroundImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setHighlightedStateBackgroundImageName:(NSString *)highlightedStateBackgroundImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(highlightedStateBackgroundImageName);

    [self setBackgroundImage:[UIImage imageNamed:highlightedStateBackgroundImageName] forState:UIControlStateHighlighted];
}

@dynamic selectedStateBackgroundImage;
- (UIImage *)selectedStateBackgroundImage {
    return [self backgroundImageForState:UIControlStateSelected];
}
- (void)setSelectedStateBackgroundImage:(UIImage *)selectedStateBackgroundImage {
    [self setBackgroundImage:selectedStateBackgroundImage forState:UIControlStateSelected];
}

@dynamic selectedStateBackgroundImageName;
- (NSString *)selectedStateBackgroundImageName {
    return GET_ASSOCIATED_OBJ();
}
- (void)setSelectedStateBackgroundImageName:(NSString *)selectedStateBackgroundImageName {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(selectedStateBackgroundImageName);

    [self setBackgroundImage:[UIImage imageNamed:selectedStateBackgroundImageName] forState:UIControlStateSelected];
}

- (void) asyncSetImageWithName:(NSString *)imageName forState:(UIControlState)state {
    [UIImage imageNamed:imageName completion:^(UIImage *image) {
        [self setImage:image forState:state];
    }];
}

- (void) asyncSetBackgroundImageWithName:(NSString *)imageName forState:(UIControlState)state {
    [UIImage imageNamed:imageName completion:^(UIImage *image) {
        [self setBackgroundImage:image forState:state];
    }];
}

- (void) centerSize:(CGSize)size imageSize:(CGSize)imageSize textSize:(CGSize)textSize spacing:(CGFloat)spacing {
    CGFloat imageSpacing = ((size.width - imageSize.height) / 2);
    CGFloat titleSpace = (size.width - textSize.width) / 2 - imageSize.width;

    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    self.imageEdgeInsets = UIEdgeInsetsMake((size.height - imageSize.height - textSize.height - spacing) / 2, imageSpacing, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(self.imageEdgeInsets.top + imageSize.height +spacing, titleSpace, 0, 0);
}

@end
