#import <ReactiveCocoa/ReactiveCocoa.h>

#define RACDealloc(signal) [(signal) takeUntil:self.rac_willDeallocSignal]

@interface RACSignal(Ext)

+ (RACSignal *)after:(NSTimeInterval)interval onScheduler:(RACScheduler *)scheduler;

@end
