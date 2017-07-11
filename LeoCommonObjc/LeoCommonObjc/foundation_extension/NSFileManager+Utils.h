#import <Foundation/Foundation.h>

@interface NSFileManager (Utils)

- (NSString *)documentPath;

- (NSString *)libraryPath;

- (NSString *)cachesPath;

- (NSString *)md5:(NSString *)path;

@end
