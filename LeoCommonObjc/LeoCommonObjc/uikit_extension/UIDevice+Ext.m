#import "UIDevice+Ext.h"
#include <sys/sysctl.h>

@implementation UIDevice(Ext)

- (NSString *)getSysInfoByName:(NSString *)typeSpecifier
{
    const char *cStr = [typeSpecifier cStringUsingEncoding:NSUTF8StringEncoding];
    
    size_t size;
    sysctlbyname(cStr, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(cStr, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:@"hw.machine"];
}

+ (BOOL) isSystemVersionGreaterThanOrEqualTo9 {
    static BOOL result = NO;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0");
    });

    return result;
}

@end
