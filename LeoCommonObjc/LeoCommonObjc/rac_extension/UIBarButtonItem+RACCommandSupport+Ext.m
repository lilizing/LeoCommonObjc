#import "UIBarButtonItem+RACCommandSupport+Ext.h"
#import "NSObject+Ext.h"
#import "RACDisposableSubscriptingAssignmentTrampoline.h"

@implementation UIBarButtonItem(RACCommandSupport_Ext)

#pragma mark - private methods

- (void)_ext_rac_commandPerformAction:(id)sender {
    if (self.rac_actionBlock) {
        self.rac_actionBlock(self);
    }
}

#pragma mark -

@dynamic rac_actionBlock;
- (BarButtonItemActionBlock)rac_actionBlock {
    return GET_ASSOCIATED_OBJ();
}
- (void)setRac_actionBlock:(BarButtonItemActionBlock)rac_actionBlock {
    SET_ASSOCIATED_OBJ_COPY_NONATOMIC(rac_actionBlock);

    if (rac_actionBlock) {
        if (self.target == self && self.action == @selector(_ext_rac_commandPerformAction:)) {
            return;
        }

        if (self.target != nil) NSLog(@"WARNING: UIBarButtonItem.rac_actionBlock hijacks the control's existing target and action.");

        self.target = self;
        self.action = @selector(_ext_rac_commandPerformAction:);
    }
    else {
        self.target = nil;
        self.action = nil;
    }
}

- (void) setEnabled:(RACSignal *)enabled actionBlock:(BarButtonItemActionBlock)actionBlock {
    RACDisposable(self, enabledDisposable) = [enabled setKeyPath:@keypath(self.enabled) onObject:self];

    self.rac_actionBlock = actionBlock;
}

@end
