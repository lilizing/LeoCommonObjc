#import "NSString+Ext.h"
#import "NSMutableString+Ext.h"
//#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Ext)

+ (NSString *)UUID{
    NSString *result = nil;
    
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithString:(__bridge NSString *)uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

- (unsigned)hexInteger{
    unsigned result = 0;
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    if (![scanner scanHexInt:&result])
        result = 0;
    
    return result;
}

//- (NSString *)md5{
//    const char *zcSrc = [self UTF8String];
//    
//    unsigned char zcDes[16];
//    CC_MD5( zcSrc, (CC_LONG)strlen(zcSrc), zcDes );
//    
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            zcDes[0], zcDes[1], zcDes[2], zcDes[3],
//            zcDes[4], zcDes[5], zcDes[6], zcDes[7],
//            zcDes[8], zcDes[9], zcDes[10], zcDes[11],
//            zcDes[12], zcDes[13], zcDes[14], zcDes[15]
//            ];
//}
//
//-(NSString *) md5_16{
//    return [[self md5] substringWithRange:NSMakeRange(8, 16)];
//}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef) self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)xmlEncode{
    return [[NSMutableString stringWithString:self] mutableXmlEncode];
}
- (NSString *)xmlDecode{
    return [[NSMutableString stringWithString:self] mutableXmlDecode];
}

- (BOOL)isAllVisualChars{
    BOOL result = NO;
    
    if ([self length]) {
        NSCharacterSet *nonVisualCharset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSScanner *scanner = [NSScanner scannerWithString:self];
        [scanner scanCharactersFromSet:nonVisualCharset intoString:nil];
        result = ![scanner isAtEnd];
    }
    
    return result;
}

+(BOOL)isNotEmptyString:(NSString *)string {
    return (string != nil && [string isKindOfClass:[NSString class]] && string.length > 0);
}

+(BOOL)isEmptyString:(NSString *)string {
    return ![NSString isNotEmptyString:string];
}

- (NSDictionary *) queryStringDict {
    return [self queryStringDictDecode:NO];
}

- (NSDictionary *) queryStringDictDecode:(BOOL)decode {
    NSMutableDictionary *result = nil;

    NSArray *queries = [self componentsSeparatedByString:@"&"];

    if (queries.count > 0) {
        result = [NSMutableDictionary dictionaryWithCapacity:queries.count];

        [queries enumerateObjectsUsingBlock:^(NSString *queryPair, NSUInteger idx, BOOL *stop) {
            NSArray *keyVal = [queryPair componentsSeparatedByString:@"="];
            if (2 == keyVal.count) {
                NSString *key = keyVal[0];
                NSString *value = keyVal[1];

                if (decode) {
                    key = [key urlDecodeUsingEncoding:NSUTF8StringEncoding];
                    value = [value urlDecodeUsingEncoding:NSUTF8StringEncoding];
                }

                result[key] = value;
            }
        }];
    }

    return result;
}


+(NSString *) jsonStringWithObject:(id) object {
    return [NSString jsonStringWithObject:object options:kNilOptions encoding:NSUTF8StringEncoding];
}

+ (NSString *) jsonStringWithObject:(id)object
                            options:(NSJSONWritingOptions)options
                           encoding:(NSStringEncoding)encoding {
    NSString *result = nil;

    NSData* jsonData = nil;
    NSError* jsonError = nil;

    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:object options:options error:&jsonError];
    }
    @catch (NSException *exception) {
        jsonData = nil;
    }

    if (jsonData && !jsonError) {
        result = [[NSString alloc] initWithData:jsonData encoding:encoding];
    }

    return result;
}

-(NSDictionary *) toDictionary {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!error) {
        return result;
    }
    return nil;
}

#pragma makr - merge spaces hold together to only one space
void mergeSpacesToOnlyOne(char s[])
{
    char *p = s;
    int FlagOfFront = 0;
    int j = 0;
    while(*p != '\0')
    {
        if(*p != ' ')
        {
            s[j++] = *p;
        }
        else
        {
            while(*p == ' ')
            {
                p++;
            }
            if(FlagOfFront == 1 || *p == '\0')
            {
                FlagOfFront = 0;
            }
            else {
                s[j++]=' ';
            }
            p--;
        }
        p++;
    }
    s[j]='\0';
}

void removeAllSpaceAtFrontOfChar(char s[])
{
    char *p = s;
    
    while (*p == ' ')
    {
        p++;
    }
    while(*p != '\0')
    {
        *s = *p;
        s++;
        p++;
    }
    *s = '\0';
}

- (NSString *)stringByTrimingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

//+ (NSString *)mergeSpacesToOneSpace:(NSString *)string {
//    const char *originCString = [string UTF8String];
//    char *buf = new char[strlen(originCString)+1];
//    strcpy(buf, originCString);
//    removeAllSpaceAtFrontOfChar(buf);
//    mergeSpacesToOnlyOne(buf);
//    NSString *targetString = [NSString stringWithUTF8String:buf];
//    delete []buf;
//    return targetString;
//}

@end
