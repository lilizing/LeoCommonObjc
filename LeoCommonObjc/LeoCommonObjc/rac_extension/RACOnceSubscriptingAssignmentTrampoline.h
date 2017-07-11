#import <ReactiveCocoa/ReactiveCocoa.h>

#define RACOnce(TARGET, ...) \
metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__)) \
(RACOnce_(TARGET, __VA_ARGS__, nil)) \
(RACOnce_(TARGET, __VA_ARGS__))

/// Do not use this directly. Use the RAC macro above.
#define RACOnce_(TARGET, KEYPATH, NILVALUE) \
[[RACOnceSubscriptingAssignmentTrampoline alloc] initWithTarget:(TARGET) nilValue:(NILVALUE)][@keypath(TARGET, KEYPATH)]

@interface RACOnceSubscriptingAssignmentTrampoline : RACSubscriptingAssignmentTrampoline

- (id)initWithTarget:(id)target nilValue:(id)nilValue;
- (void)setObject:(RACSignal *)signal forKeyedSubscript:(NSString *)keyPath;

@end
