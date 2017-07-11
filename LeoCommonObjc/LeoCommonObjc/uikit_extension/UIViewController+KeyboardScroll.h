#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollViewInsetsAdjustStyle) {
    ScrollViewInsetsAdjustStyleNone,
    ScrollViewInsetsAdjustStyleFrame,
    ScrollViewInsetsAdjustStyleContentInsets
};

@protocol ScrollViewInsetsAdjust

@property (nonatomic, assign) ScrollViewInsetsAdjustStyle scrollViewInsetsAdjustStyle;

// default: YES
@property (nonatomic, assign) BOOL inheritParentViewControllerScrollViewInsets;

- (UIScrollView *)scrollViewToAdjustInsets;

/*
 * scroll view insets to apply.
 * Override when you want to return customized insets.
 */
- (UIEdgeInsets) scrollViewInsets;

- (void)updateScrollViewInsets;

@end

@interface UIViewController (KeyboardScroll)

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

- (void) setupKeyboardAutoScrollable;

@end
