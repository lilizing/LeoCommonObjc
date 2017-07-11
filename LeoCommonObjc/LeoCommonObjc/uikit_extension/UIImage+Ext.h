#import <UIKit/UIKit.h>

@interface UIImage(Ext)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (void)imageNamed:(NSString *)name completion:(void (^)(UIImage *image))completion;

- (NSData *)compressedJPEGData;

- (void)decodedImage;

- (UIImage *)scaleImageToSize:(CGSize)size;

+ (instancetype) imageWithNameIfExist:(NSString *)imageName;

@end
