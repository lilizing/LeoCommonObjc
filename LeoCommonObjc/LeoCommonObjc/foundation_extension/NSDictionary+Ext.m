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

+ (NSString*)toString:(NSDictionary *)infoDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    if (!jsonData){
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}
@end
