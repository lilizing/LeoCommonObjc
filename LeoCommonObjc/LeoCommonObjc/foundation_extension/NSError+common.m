#import "NSError+common.h"
#import "NSString+Ext.h"

@implementation NSError(common)

+ (instancetype) noInternetConnectionError {
    return [[NSError alloc] initWithDomain:NSURLErrorDomain
                                      code:NSURLErrorNotConnectedToInternet
                                  userInfo:nil];
}

- (BOOL) isNetworkError {
   return [self isKindOfClass:[NSError class]] && [self.domain isEqualToString:NSURLErrorDomain];
}

- (BOOL) isNoInternetConnectionError {
    return [self isNetworkError] && self.code == NSURLErrorNotConnectedToInternet;
}

- (BOOL) isConnectionTimeoutError {
    return [self isNetworkError] && self.code == NSURLErrorTimedOut;
}

@end
