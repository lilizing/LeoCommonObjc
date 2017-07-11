#import <Foundation/Foundation.h>

@interface NSError(common)

+ (instancetype) noInternetConnectionError;

- (BOOL) isNetworkError;

- (BOOL) isNoInternetConnectionError;
- (BOOL) isConnectionTimeoutError;

@end
