#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIDevice+Ext.h"

#define VIEW_MARGIN (IS_IPHONE_6P?16.0f:(IS_IPHONE_6?12.0f:10.0f))
#define VIEW_MARGIN_HALF (IS_IPHONE_6P?8.0f:(IS_IPHONE_6?6.0f:5.0f))

#define SOLID_VIEW_MARGIN 8.f
#define SOLID_VIEW_MARGIN_HALF 4.0f

#define SEPERATOR_HEIGHT (1.f / UIScreen.mainScreen.scale)

/*
 * Can only show while define DEBUG
 
 * C functions can be totally erased by the compiler, if DEUBG is not defined.
 */
void debugHighlightViewBorderColorWidth(UIView *view, UIColor *color, CGFloat width);
void debugHighlightViewBorder(UIView *view);
void debugHighlightViewBkgColor(UIView *view);

@interface UIView(Ext)

- (void) printViewHierarchy;
- (void) printSuperViewHierarchy;

+ (UIViewAnimationOptions) animationOptionsWithCurve:(UIViewAnimationCurve)curve;

+ (instancetype) viewFromClassNib;

- (RACSignal *)rac_signalForTap;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat absoluteLeft;
@property (nonatomic, assign) CGFloat absoluteRight;
@property (nonatomic, assign) CGFloat absoluteTop;
@property (nonatomic, assign) CGFloat absoluteBottom;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, readonly) CGFloat screenX;
@property (nonatomic, readonly) CGFloat screenY;

@property (nonatomic, readonly) CGFloat screenViewX;
@property (nonatomic, readonly) CGFloat screenViewY;

@property (nonatomic, readonly) CGRect screenFrame;

@property (nonatomic, readonly) CGFloat orientationWidth;
@property (nonatomic, readonly) CGFloat orientationHeight;

- (void)centerInRect:(CGRect)rect;
- (void)centerVerticallyInRect:(CGRect)rect;
- (void)centerHorizontallyInRect:(CGRect)rect;

- (void)centerInSuperView;
- (void)centerVerticallyInSuperView;
- (void)centerHorizontallyInSuperView;

- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding;
- (void)centerHorizontallyBelow:(UIView *)view;

- (UIView*)descendantOrSelfWithClass:(Class)cls;
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

- (void)removeAllSubviews;

- (void)pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute;
- (void)pinAllEdgesOfSubview:(UIView *)subview;

+ (id)viewFromNibNamed:(NSString *)nibName;
+ (id)viewFromNibNamed:(NSString *)nibName viewName:(NSString *)viewName;
+ (id)viewWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)showAlert;
- (void)dismissAlert;

@end
