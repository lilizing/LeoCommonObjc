#import <ReactiveCocoa/ReactiveCocoa.h>

#define RACDisposable(TARGET, KEY) \
[[RACDisposableSubscriptingAssignmentTrampoline alloc] initWithTarget:(TARGET)][@#KEY]

@interface RACDisposableSubscriptingAssignmentTrampoline : NSObject

- (id)initWithTarget:(NSObject *)target;

- (RACDisposable *) objectForKeyedSubscript:(NSString *)keyPath;
- (void)setObject:(RACDisposable *)disposable forKeyedSubscript:(NSString *)keyPath;

@end
