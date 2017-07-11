#import <Foundation/Foundation.h>

@interface NSURL(Ext)

- (BOOL) isHttpProtocol;

// queryDict 会自动 url decode query 中的 key 和 value。
- (NSDictionary *) queryDict;
- (NSDictionary *) queryDictDecode:(BOOL)decode;

- (NSString *)rootHost;

// override existed keys by default
- (NSURL *)URLByAppendingQueryDict:(NSDictionary *)queryDict;

- (NSURL *)URLByAppendingQueryDict:(NSDictionary *)queryDict override:(BOOL)override;

@end
