#import "UIAlertView+RACCommandSupport+Ext.h"
#import "RACDelegateProxy.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
#import <objc/runtime.h>

@implementation UIAlertView (RACCommandSupport_Ext)

static void RACUseDelegateProxy(UIAlertView *self) {
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACSignal *)rac_didDismissSignal {
    RACSignal *signal = [[[[self.rac_delegateProxy
                            signalForSelector:@selector(alertView:didDismissWithButtonIndex:)]
                           reduceEach:^(UIAlertView *alertView, NSNumber *buttonIndex) {
                               return buttonIndex;
                           }]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@"%@ -rac_didDismissSignal", self.rac_description];
    
    RACUseDelegateProxy(self);
    
    return signal;
}

@end
