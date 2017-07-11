#import "RACSignal+Ext.h"

@implementation RACSignal(Ext)

+ (RACSignal *)after:(NSTimeInterval)interval onScheduler:(RACScheduler *)scheduler {
    NSCParameterAssert(scheduler != nil);
    NSCParameterAssert(scheduler != RACScheduler.immediateScheduler);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [scheduler afterDelay:interval schedule:^{
            [subscriber sendNext:[NSDate date]];
            [subscriber sendCompleted];
        }];
    }] setNameWithFormat:@"+after: %f onScheduler: %@", (double)interval, scheduler];
}

@end
