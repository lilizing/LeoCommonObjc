#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NSObject(RAC_Ext)

- (RACSignal *) observeNotification:(NSString *)notificationName;
- (RACSignal *) observeNotification:(NSString *)notificationName object:(id)object;

@end
