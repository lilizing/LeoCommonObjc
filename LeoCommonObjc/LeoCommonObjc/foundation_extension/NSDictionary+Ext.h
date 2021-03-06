#import <Foundation/Foundation.h>

@interface NSDictionary(Ext)

+ (BOOL)isNotEmpty:(NSDictionary *)dict;

- (NSString *)queryString;

- (NSDictionary *)reverseKeyValueDictionary;

+ (NSString*)toString:(NSDictionary *)infoDict;

@end
