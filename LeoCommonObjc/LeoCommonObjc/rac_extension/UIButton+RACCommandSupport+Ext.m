#import "UIButton+RACCommandSupport+Ext.h"
#import "NSObject+Ext.h"
#import "RACDisposableSubscriptingAssignmentTrampoline.h"

@implementation UIButton(RACCommandSupport_Ext)

@dynamic rac_actionBlock;
- (ButtonActionBlock)rac_actionBlock {
    return GET_ASSOCIATED_OBJ();
}
- (void)setRac_actionBlock:(ButtonActionBlock)rac_actionBlock {
    SET_ASSOCIATED_OBJ_COPY_NONATOMIC(rac_actionBlock);

    @weakify(self)
    
    if (!RACDisposable(self, touchUpInsideDisposable)) {
        RACDisposable(self, touchUpInsideDisposable) = \
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id _) {
            @strongify(self)
            
            if(self.rac_actionBlock) {
                self.rac_actionBlock(self);
            }
        }];
    }
}

#pragma mark -

- (void) setEnabled:(RACSignal *)enabled actionBlock:(ButtonActionBlock)actionBlock {
    RACDisposable(self, enabledDisposable) = [enabled setKeyPath:@keypath(self.enabled) onObject:self];

    self.rac_actionBlock = actionBlock;
}

@end
