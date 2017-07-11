#import <UIKit/UIKit.h>

@interface UIViewController(Ext)

+ (instancetype) rootViewController;

- (BOOL)isVisible;

/*
 * provide best practice for addChildViewController and removeFronParentViewController
 */
- (void) ext_addChildViewController:(UIViewController *)childViewController;
- (void) ext_addChildViewController:(UIViewController *)childViewController setup:(void (^)())block;
- (void) ext_removeFromParentViewController;
- (void) ext_removeFromParentViewControllerTearDown:(void(^)())block;

@end
