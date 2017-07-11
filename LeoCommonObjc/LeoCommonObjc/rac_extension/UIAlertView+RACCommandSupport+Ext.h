#import <UIKit/UIKit.h>
#import "UIAlertView+RACSignalSupport.h"

@interface UIAlertView (RACCommandSupport_Ext)

- (RACSignal *)rac_didDismissSignal;

@end
