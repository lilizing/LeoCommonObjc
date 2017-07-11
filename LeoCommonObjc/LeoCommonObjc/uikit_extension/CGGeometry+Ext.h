#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define CGSizeMax CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)

typedef NS_ENUM(NSInteger, CGRectFlowAlignment) {
    CGRectFlowAlignmentLeft     = 1 << 0,
    CGRectFlowAlignmentRight    = 1 << 1,
    CGRectFlowAlignmentCenterX  = 1 << 2,
    CGRectFlowAlignmentTop      = 1 << 3,
    CGRectFlowAlignmentBottom   = 1 << 4,
    CGRectFlowAlignmentCenterY  = 1 << 5,
};

CG_INLINE CGRect CGRectFlowRectX(CGRect rect, CGSize size, CGFloat margin, CGRectFlowAlignment alignment) {
    CGFloat y = rect.origin.y;

    if (alignment & CGRectFlowAlignmentBottom) {
        y = rect.origin.y + rect.size.height - size.height;
    }
    else if (alignment & CGRectFlowAlignmentCenterY) {
        y = rect.origin.y + (rect.size.height - size.height) / 2;
    }

    return CGRectMake(CGRectGetMaxX(rect) + (rect.size.width > 0.001f ? margin : 0.f),
            y,
            size.width,
            size.height);
}

CG_INLINE CGRect CGRectFlowRectY(CGRect rect, CGSize size, CGFloat margin, CGRectFlowAlignment alignment) {
    CGFloat x = rect.origin.x;

    if (alignment & CGRectFlowAlignmentRight) {
        x = rect.origin.x + rect.size.width - size.width;
    }
    else if (alignment & CGRectFlowAlignmentCenterX) {
        x = rect.origin.x + (rect.size.width - size.width) / 2;
    }

    return CGRectMake(x,
            CGRectGetMaxY(rect) + (rect.size.height > 0.001f ? margin : 0.f),
            size.width,
            size.height);
}

CG_INLINE CGPoint CGRectGetCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGFloat CGRectOriginYCenterWithRect(CGRect rect, CGFloat height) {
    return CGRectGetMinY(rect) + (rect.size.height - height) / 2;
}

CG_INLINE CGRect CGRectMakeIntegral(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectIntegral(CGRectMake(x, y, width, height));
}