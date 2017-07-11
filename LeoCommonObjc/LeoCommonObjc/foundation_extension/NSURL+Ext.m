#import "NSURL+Ext.h"
#import "NSString+Ext.h"
#import "NSDictionary+Ext.h"

@implementation NSURL(Ext)

- (BOOL) isHttpProtocol {
    return [self.scheme isEqualToString:@"http"] || [self.scheme isEqualToString:@"https"];
}

- (NSDictionary *) queryDict {
    return [self.query queryStringDictDecode:YES];
}
- (NSDictionary *) queryDictDecode:(BOOL)decode {
    return [self.query queryStringDictDecode:decode];
}

- (NSString *)rootHost {
    NSString *result = nil;

    NSString *host = self.host;
    if (![NSString isNotEmptyString:host]) {
        return result;
    }

    NSArray<NSString *> *hostComponents = [host componentsSeparatedByString:@"."];
    if (hostComponents.count >= 2) {
        NSArray *rootComponents = [hostComponents subarrayWithRange:NSMakeRange(hostComponents.count - 2, 2)];
        result = [rootComponents componentsJoinedByString:@"."];
    }

    return result;
}

- (NSURL *)URLByAppendingQueryDict:(NSDictionary *)queryDict {
    return [self URLByAppendingQueryDict:queryDict override:YES];
}

- (NSURL *)URLByAppendingQueryDict:(NSDictionary *)queryDict override:(BOOL)override {
    if (!queryDict.count) {
        return self;
    }

    NSDictionary *oldQuertDict = [self queryDictDecode:NO];
    NSMutableDictionary *newQueryDict = [NSMutableDictionary dictionaryWithDictionary:oldQuertDict];
    [queryDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        if (![oldQuertDict valueForKey:key] || override) {
            [newQueryDict setValue:value forKey:key];
        }
    }];

    if ([oldQuertDict isEqualToDictionary:newQueryDict]) {
        return self;
    }

    // scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]

    NSString *scheme = @"";
    if ([NSString isNotEmptyString:self.scheme]) {
        scheme = [NSString stringWithFormat:@"%@:", self.scheme];
    }

    NSString *base = @"";
    // base
    {
        NSString *userPassword = @"";
        if ([NSString isNotEmptyString:self.user] || [NSString isNotEmptyString:self.password]) {
            if ([NSString isNotEmptyString:self.user] && [NSString isNotEmptyString:self.password]) {
                userPassword = [NSString stringWithFormat:@"%@:%@@", self.user, self.password];
            }
            else {
                userPassword = [NSString stringWithFormat:@"%@%@@",nilToEmptyStr(self.user), nilToEmptyStr(self.password)];
            }
        }

        NSString *port = @"";
        if ([NSString isNotEmptyString:self.port]) {
            port = [NSString stringWithFormat:@":%@", self.port];
        }

        base = [NSString stringWithFormat:@"%@%@%@", userPassword, nilToEmptyStr(self.host), port];
        if ([NSString isNotEmptyString:base]) {
            base = [NSString stringWithFormat:@"//%@", base];
        }
    }

    NSString *path = @"";
    if ([NSString isNotEmptyString:self.path]) {
        path = self.path;

        if ([self.path characterAtIndex:0] != '/') {
            path = [NSString stringWithFormat:@"/%@", self.path];
        }
    }

    NSString *query = nilToEmptyStr([newQueryDict queryString]);
    if ([NSString isNotEmptyString:query]) {
        query = [NSString stringWithFormat:@"?%@", query];
    }

    NSString *fragment = @"";
    if ([NSString isNotEmptyString:self.fragment]) {
        fragment = [NSString stringWithFormat:@"#%@", self.fragment];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@%@", scheme, base, path, query, fragment];
    return [NSURL URLWithString:URLString];
}

@end
