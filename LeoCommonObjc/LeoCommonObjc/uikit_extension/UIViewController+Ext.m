#import "UIViewController+Ext.h"
#import "NSObject+Ext.h"

@implementation UIViewController(Ext)

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window != nil;
}

+ (instancetype) rootViewController {
    return UIApplication.sharedApplication.keyWindow.rootViewController;
}

- (void) ext_addChildViewController:(UIViewController *)childViewController {
    [self ext_addChildViewController:childViewController setup:^{
        [self.view addSubview:childViewController.view];
    }];
}

- (void) ext_addChildViewController:(UIViewController *)childViewController setup:(void (^)())block {
    if (childViewController.parentViewController == self) {
        return;
    }
    
    [self addChildViewController:childViewController];

    if (block) {
        block();
    }

    [childViewController didMoveToParentViewController:self];
}

- (void) ext_removeFromParentViewController {
    [self ext_removeFromParentViewControllerTearDown:^{
        [self.view removeFromSuperview];
    }];
}

- (void) ext_removeFromParentViewControllerTearDown:(void(^)())block {
    if (!self.parentViewController) {
        return;
    }

    [self willMoveToParentViewController:nil];

    if (block) {
        block();
    }

    [self removeFromParentViewController];
}

@end
