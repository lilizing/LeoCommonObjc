#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define nilToEmptyStr(str) ((str) ? (str) : @"")
#define nilToEmptyStr2(str1, str2) ((str1) ? (str1) : ((str2) ? (str2) : @""))

#define emptyStrToNil(str) ([NSString isNotEmptyString:(str)] ? (str) : nil)
#define emptyStrToNSNull(str) ([NSString isNotEmptyString:(str)] ? (str) : [NSNull null])
#define urlEncodeUTF8Str(str) ([nilToEmptyStr(str) urlEncodeUsingEncoding:NSUTF8StringEncoding])

@interface NSString(Ext)

+ (NSString *)UUID;

- (unsigned)hexInteger;

- (NSString *)md5;
- (NSString *)md5_16;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)xmlEncode;
- (NSString *)xmlDecode;

- (BOOL)isAllVisualChars;

- (NSDictionary *) queryStringDict;
- (NSDictionary *) queryStringDictDecode:(BOOL)decode;

+ (BOOL) isNotEmptyString:(NSString *)string;

+ (NSString *) jsonStringWithObject:(id)object;
+ (NSString *) jsonStringWithObject:(id)object
                            options:(NSJSONWritingOptions)options
                           encoding:(NSStringEncoding)encoding;

//+ (NSString *)mergeSpacesToOneSpace:(NSString *)string;

- (NSDictionary *) toDictionary;

- (NSString *)stringByTrimingWhitespace;
- (NSUInteger)numberOfLines;

@end
