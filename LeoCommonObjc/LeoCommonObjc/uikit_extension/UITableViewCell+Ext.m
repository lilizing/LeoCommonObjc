#import "UITableViewCell+Ext.h"

@implementation UITableViewCell(Ext)

- (void) alignSeparatorToLeftBorder {
    [self updateSeperatorEdgeInset:UIEdgeInsetsZero];
}

- (void) hideSeperator {
    [self updateSeperatorEdgeInset:UIEdgeInsetsMake(0.f, [UIScreen mainScreen].applicationFrame.size.width + 1.f, 0.f, 0.f)];
}

- (void) updateSeperatorEdgeInset:(UIEdgeInsets) inset {
    [self setSeparatorInset:inset];

    // iOS 8 only
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:inset];
    }
}

@end
