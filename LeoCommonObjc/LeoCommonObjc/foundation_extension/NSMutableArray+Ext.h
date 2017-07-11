#import <Foundation/Foundation.h>

@interface NSMutableArray(Ext)

/*
 * Create a mutable array that do not retain its' items
 */
+ (instancetype)noneRetainItemArray;
- (void)addObjectIfNotNil:(id)anObject;

@end
