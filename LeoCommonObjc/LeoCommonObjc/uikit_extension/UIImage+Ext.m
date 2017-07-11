#import "UIImage+Ext.h"
#import <libkern/OSAtomic.h>
#import "NSObject+Ext.h"
#import "NSString+Ext.h"
#import "UIDevice+Ext.h"

@implementation UIImage(Ext)

#pragma mark -

- (UIImage *)_scaleImageToSize:(CGSize)size
          interpolationQuality:(CGInterpolationQuality)interpolationQuality{
    UIImage *result = nil;

    CGImageRef cgImage = self.CGImage;
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 CGImageGetBitsPerComponent(cgImage),
                                                 CGImageGetBytesPerRow(cgImage),
                                                 CGImageGetColorSpace(cgImage),
                                                 CGImageGetBitmapInfo(cgImage));

    CGContextSetInterpolationQuality(context, interpolationQuality);
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, size.width, size.height), cgImage);

    CGImageRef newImage = CGBitmapContextCreateImage(context);
    result = [UIImage imageWithCGImage:newImage];
    CGContextRelease(context);
    CGImageRelease(newImage);

    return result;
}

#pragma mark -

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (void)imageNamed:(NSString *)name completion:(void (^)(UIImage *))completion {
    if (![NSString isNotEmptyString:name]) {
        if (completion) {
            completion(nil);
        }
        return;
    }

    // async creat UIImage and decode in background thread, then return to the source queue
    if ([UIDevice isSystemVersionGreaterThanOrEqualTo9]) {
        dispatch_queue_t sourceQueue = dispatch_get_current_queue();

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [UIImage imageNamed:name];
            [image decodedImage];

            if (completion) {
                dispatch_async(sourceQueue, ^{
                    completion(image);
                });
            }
        });
    }
    // since imageNamed is not thread safe under iOS 9, so create image synchronizedlly.
    else {
        UIImage *image = [UIImage imageNamed:name];
        if (completion) {
            completion(image);
        }
    }
}

- (NSData *)compressedJPEGData{
    
    // 0.75 lossy compresss quality is almost default compress quality of ImageIO.
    return UIImageJPEGRepresentation(self, .75f);
    
    // For compability reason, drop ImageIO
    /*
     NSMutableData *result = [NSMutableData data];
     
     CGImageDestinationRef tmpImgDes = NULL;
     tmpImgDes = CGImageDestinationCreateWithData((CFMutableDataRef)result, kUTTypeJPEG, 1, NULL);
     
     CGImageDestinationAddImage(tmpImgDes, self.CGImage, NULL);
     CGImageDestinationFinalize(tmpImgDes);
     CFRelease(tmpImgDes);
     
     return result;
     */
}

- (void)decodedImage {
    // use smallest memory, just force the image decoding before drawing
    CGSize size = CGSizeMake(1.f, 1.f);
    [self _scaleImageToSize:size interpolationQuality:kCGInterpolationLow];
}

- (UIImage *)scaleImageToSize:(CGSize)size {
    return [self _scaleImageToSize:size interpolationQuality:kCGInterpolationDefault];
}

+ (instancetype) imageWithNameIfExist:(NSString *)imageName {
    return [NSString isNotEmptyString:imageName] ? [UIImage imageNamed:imageName] : nil;
}

@end
