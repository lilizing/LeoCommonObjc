#import <UIKit/UIKit.h>

@interface UIButton(Ext)

@property (nonatomic, strong) NSString *normalStateTitle;
@property (nonatomic, strong) NSAttributedString *normalStateAttributedTitle;

@property (nonatomic, strong) UIImage *normalStateImage;
@property (nonatomic, strong) NSString *normalStateImageName;

@property (nonatomic, strong) UIImage *disabledStateImage;
@property (nonatomic, strong) NSString *disabledStateImageName;

@property (nonatomic, strong) UIImage *highlightedStateImage;
@property (nonatomic, strong) NSString *highlightedStateImageName;

@property (nonatomic, strong) UIImage *selectedStateImage;
@property (nonatomic, strong) NSString *selectedStateImageName;

@property (nonatomic, strong) UIImage *normalStateBackgroundImage;
@property (nonatomic, strong) NSString *normalStateBackgroundImageName;

@property (nonatomic, strong) UIImage *disabledStateBackgroundImage;
@property (nonatomic, strong) NSString *disabledStateBackgroundImageName;

@property (nonatomic, strong) UIImage *highlightedStateBackgroundImage;
@property (nonatomic, strong) NSString *highlightedStateBackgroundImageName;

@property (nonatomic, strong) UIImage *selectedStateBackgroundImage;
@property (nonatomic, strong) NSString *selectedStateBackgroundImageName;

- (void) asyncSetImageWithName:(NSString *)imageName forState:(UIControlState)state;
- (void) asyncSetBackgroundImageWithName:(NSString *)imageName forState:(UIControlState)state;

- (void) centerSize:(CGSize)size imageSize:(CGSize)imageSize textSize:(CGSize)textSize spacing:(CGFloat)spacing;

@end
