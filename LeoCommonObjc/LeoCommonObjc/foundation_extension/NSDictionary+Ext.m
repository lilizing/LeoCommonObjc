#import "NSDictionary+Ext.h"
#import "NSString+Ext.h"

@implementation NSDictionary(Ext)

+ (BOOL)isNotEmpty:(NSDictionary *)dict {
    return [dict isKindOfClass:[NSDictionary class]] && [dict count] > 0;
}

- (NSString *)queryString {
    NSMutableString *result = [NSMutableString string];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [result appendFormat:@"%@=%@&", key, value];
    }];
    
    if (result.length) {
        [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
    }
    
    return result;
}

- (NSDictionary *)reverseKeyValueDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [result setValue:key forKey:value];
    }];
    
    return result;
}

@end
