#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACDisposableSubscriptingAssignmentTrampoline.h"

#define RACObserveOnce(TARGET, KEYPATH) \
({\
NSString *key = @#TARGET"."#KEYPATH;\
RACSubject *cancelSubject = [self cancelPreviousObservingSignalForKey:key];\
[cancelSubject sendCompleted];\
[RACObserve(TARGET, KEYPATH) takeUntil:cancelSubject];\
})

@interface NSObject(RACPropertySubscribing_Ext)

- (RACSubject *) cancelPreviousObservingSignalForKey:(NSString *)key;

@end
