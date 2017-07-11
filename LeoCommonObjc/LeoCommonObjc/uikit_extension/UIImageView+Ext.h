#import <UIKit/UIKit.h>

@interface UIImageView(Ext)

- (void) roundImageView;
- (void) roundImageViewWithBorder;

- (void) asyncSetImageWithName:(NSString *)imageName;
- (void) asyncSetHighlightedImageWithName:(NSString *)imageName;

@end
