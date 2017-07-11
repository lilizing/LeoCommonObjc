#import "UIView+Ext.h"
#import "UIColor+Ext.h"
#import "NSObject+RACDescription.h"
#import <objc/runtime.h>

void debugHighlightViewBorderColorWidth(UIView *view, UIColor *color, CGFloat width){
#if DEBUG
    CALayer *layer = [view layer];
    layer.borderColor = color.CGColor;
    layer.borderWidth = width;
#endif
}
void debugHighlightViewBorder(UIView *view){
#if DEBUG
    debugHighlightViewBorderColorWidth(view, [UIColor randomColor], 2);
#endif
}
void debugHighlightViewBkgColor(UIView *view){
#if DEBUG
    CALayer *theLayer = [view layer];
    theLayer.backgroundColor = [UIColor randomColor].CGColor;
#endif
}

@implementation UIView(Ext_private)

- (void) _printViewHierarchyWithIndentLevel:(NSUInteger)indentLevel{
    
    NSMutableString *indentSpaces = [NSMutableString stringWithCapacity:indentLevel];
    for (int i = 0; i < indentLevel; ++i) {
        [indentSpaces appendString:@" "];
    }
    
    NSLog(@"%@%@",indentSpaces, self);
    
    for (UIView *subView in self.subviews) {
        [subView _printViewHierarchyWithIndentLevel:indentLevel + 2];
    }
}

- (void)_printSuperViewHierarchyWithIndentLevel:(NSUInteger)indentLevel{
    NSMutableString *indentSpaces = [NSMutableString stringWithCapacity:indentLevel];
    for (int i = 0; i < indentLevel; ++i) {
        [indentSpaces appendString:@" "];
    }
    
    NSLog(@"%@%@",indentSpaces, self);
    
    UIView *superView = self.superview;
    if (superView) {
        [superView _printSuperViewHierarchyWithIndentLevel: indentLevel + 2];
    }
}

@end

@implementation UIView(Ext)

- (void) printViewHierarchy{
    [self _printViewHierarchyWithIndentLevel:0];
}

- (void)printSuperViewHierarchy{
    [self _printSuperViewHierarchyWithIndentLevel:0];
}

+ (UIViewAnimationOptions) animationOptionsWithCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
    }
    return 0;
}

+ (instancetype) viewFromClassNib {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
    return [nib instantiateWithOwner:nil options:nil][0];
}


static char kRACActionHandlerTapGestureKey;

- (RACSignal *)rac_signalForTap{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kRACActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] init];
        gesture.delegate = (id)self;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kRACActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
        @weakify(self, gesture)
        [self.rac_willDeallocSignal subscribeNext:^(id x) {
            @strongify(self, gesture)
            [self removeGestureRecognizer:gesture];
        }];
    }
    return gesture.rac_gestureSignal;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size;
{
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGSize)size;
{
    return [self frame].size;
}

- (CGFloat)left;
{
    return CGRectGetMinX([self frame]);
}

- (void)setLeft:(CGFloat)x;
{
    CGRect frame = [self frame];
    frame.origin.x = x;
    [self setFrame:frame];
}

- (CGFloat)top;
{
    return CGRectGetMinY([self frame]);
}

- (void)setTop:(CGFloat)y;
{
    CGRect frame = [self frame];
    frame.origin.y = y;
    [self setFrame:frame];
}

- (CGFloat)right;
{
    return CGRectGetMaxX([self frame]);
}

- (void)setRight:(CGFloat)right;
{
    CGRect frame = [self frame];
    frame.origin.x = right - frame.size.width;
    [self setFrame:frame];
}

- (CGFloat)bottom;
{
    return CGRectGetMaxY([self frame]);
}

- (void)setBottom:(CGFloat)bottom;
{
    CGRect frame = [self frame];
    frame.origin.y = bottom - frame.size.height;
    
    
    [self setFrame:frame];
}

@dynamic absoluteLeft;
- (CGFloat)absoluteLeft {
    
    return self.left;
}

- (void)setAbsoluteLeft:(CGFloat)absoluteLeft {
    
    CGRect frame = [self frame];
    frame.size.width += frame.origin.x - absoluteLeft;
    frame.origin.x = absoluteLeft;
    [self setFrame:frame];
}

@dynamic absoluteRight;
- (CGFloat)absoluteRight {
    
    return self.right;
}

- (void)setAbsoluteRight:(CGFloat)absoluteRight {
    
    CGRect frame = [self frame];
    frame.size.width = absoluteRight - frame.origin.x;
    [self setFrame:frame];
}

@dynamic absoluteTop;
- (CGFloat)absoluteTop {
    
    return self.top;
}

- (void)setAbsoluteTop:(CGFloat)absoluteTop {
    
    CGRect frame = [self frame];
    frame.size.height += frame.origin.y - absoluteTop;
    frame.origin.y = absoluteTop;
    [self setFrame:frame];
}

@dynamic absoluteBottom;
- (CGFloat)absoluteBottom {
    
    return self.bottom;
}

- (void)setAbsoluteBottom:(CGFloat)absoluteBottom {
    
    CGRect frame = [self frame];
    frame.size.height = absoluteBottom - frame.origin.y;
    [self setFrame:frame];
}





- (CGFloat)centerX;
{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX;
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)centerY;
{
    return [self center].y;
}

- (void)setCenterY:(CGFloat)centerY;
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)width;
{
    return CGRectGetWidth([self frame]);
}

- (void)setWidth:(CGFloat)width;
{
    CGRect frame = [self frame];
    frame.size.width = width;
    [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)height;
{
    return CGRectGetHeight([self frame]);
}

- (void)setHeight:(CGFloat)height;
{
    CGRect frame = [self frame];
    frame.size.height = height;
    [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)screenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)screenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.height : self.width;
}

- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.width : self.height;
}

//针对给定的坐标系居中
- (void)centerInRect:(CGRect)rect;
{
    //如果参数是小数，则求最大的整数但不大于本身.
    //CGRectGetMidX获取中心点的X轴坐标
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

//针对给定的坐标系纵向居中
- (void)centerVerticallyInRect:(CGRect)rect;
{
    [self setCenter:CGPointMake([self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}


//针对给定的坐标系横向居中
- (void)centerHorizontallyInRect:(CGRect)rect;
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), [self center].y)];
}

//相对父视图居中
- (void)centerInSuperView;
{
    [self centerInRect:[[self superview] bounds]];
}

- (void)centerVerticallyInSuperView;
{
    [self centerVerticallyInRect:[[self superview] bounds]];
}

- (void)centerHorizontallyInSuperView;
{
    [self centerHorizontallyInRect:[[self superview] bounds]];
}

//同一父视图的兄弟视图水平居中
- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding;
{
    // for now, could use screen relative positions.
    NSAssert([self superview] == [view superview], @"views must have the same parent");
    
    [self setCenter:CGPointMake([view center].x,
                                floorf(padding + CGRectGetMaxY([view frame]) + ([self height] / 2)))];
}

- (void)centerHorizontallyBelow:(UIView *)view;
{
    [self centerHorizontallyBelow:view padding:0];
}

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:subview
                                                     attribute:attribute
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (void)pinAllEdgesOfSubview:(UIView *)subview
{
    [self pinSubview:subview toEdge:NSLayoutAttributeBottom];
    [self pinSubview:subview toEdge:NSLayoutAttributeTop];
    [self pinSubview:subview toEdge:NSLayoutAttributeLeading];
    [self pinSubview:subview toEdge:NSLayoutAttributeTrailing];
}

+ (id)viewFromNibNamed:(NSString *)nibName
{
    NSArray *nibViews = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(nibName)]) {
            return object;
        }
    }
    if (nibViews) {
        return [nibViews objectAtIndex:0];
    }
    return nil;
}

+ (id)viewFromNibNamed:(NSString *)nibName viewName:(NSString *)viewName
{
    NSArray *nibViews = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(viewName)]) {
            return object;
        }
    }
    if (viewName == nil && nibViews) {
        return [nibViews objectAtIndex:0];
    }
    return nil;
}


+ (id)viewWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    UIView *result = nil;
    
    NSArray *nibViews = [(nibBundleOrNil ? nibBundleOrNil : [NSBundle mainBundle]) loadNibNamed:nibNameOrNil owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(nibNameOrNil)]) {
            result = object;
            break;
        }
    }
    
    return result;
}

- (void)showAlert {
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)dismissAlert {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
