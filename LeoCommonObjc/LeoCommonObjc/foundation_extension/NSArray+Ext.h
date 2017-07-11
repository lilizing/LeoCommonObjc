#import <Foundation/Foundation.h>

@interface NSArray(Ext)

+ (BOOL)isNotEmptyArray:(id)array;

- (BOOL)isEqualToArray:(NSArray *)otherArray
           compareBlock:(BOOL(^)(id obj1, id obj2))compareBlock;

+ (BOOL)isIndex:(NSInteger)index inArray:(NSArray *)array;

- (id)objectAtIndexIfExist:(NSUInteger)index;

- (NSMutableArray*)zipWithGroupNum:(NSInteger)num;

- (NSMutableArray*)unzip;

+ (NSArray *) arrayWithObjectIfNotNil:(id)object;

@end
