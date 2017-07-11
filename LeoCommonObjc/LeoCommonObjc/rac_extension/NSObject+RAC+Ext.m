#import "NSObject+RAC+Ext.h"
#import "RACSignal+Ext.h"

@implementation NSObject(RAC_Ext)

- (RACSignal *) observeNotification:(NSString *)notificationName {
    return [self observeNotification:notificationName object:nil];
}

- (RACSignal *) observeNotification:(NSString *)notificationName object:(id)object {
    return RACDealloc([[NSNotificationCenter defaultCenter] rac_addObserverForName:notificationName object:object]);
}

@end
