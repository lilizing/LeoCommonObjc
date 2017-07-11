#import "NSObject+RACPropertySubscribing+Ext.h"
#import "NSObject+Ext.h"

@implementation NSObject(RACPropertySubscribing_Ext)

- (RACSubject *) cancelPreviousObservingSignalForKey:(NSString *)key {
    RACSubject *result = nil;
    
    @synchronized (self) {
        NSMutableDictionary *cancelPreviousObservingSignalMap = \
        objc_getAssociatedObject(self, @"cancelPreviousObservingSignalMap");
        
        if (!cancelPreviousObservingSignalMap) {
            cancelPreviousObservingSignalMap = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, @"cancelPreviousObservingSignalMap", cancelPreviousObservingSignalMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        result = cancelPreviousObservingSignalMap[key];
        if (!result) {
            result = [RACSubject subject];
            cancelPreviousObservingSignalMap[key] = result;
        }
    }
    
    return result;
}

@end
