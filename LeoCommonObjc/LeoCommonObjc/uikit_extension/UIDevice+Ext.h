#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH >= 568.0 && SCREEN_MAX_LENGTH < 667.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 667.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0 && SCREEN_MAX_LENGTH < 736.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH >= 736.0)

#define RATO_6_6P (667.0 / 736.0)
#define RATO_5_6P (568.0 / 736.0)

#define RATO_6P_6 (736.0 / 667.0)
#define RATO_5_6 (568.0 / 667.0)

#define RATO_6P_5 (736.0 / 568.0)
#define RATO_6_5 (667.0 / 568.0)

@interface UIDevice(Ext)

- (NSString *)getSysInfoByName:(NSString *)typeSpecifier;

- (NSString *)modelIdentifier;

+ (BOOL) isSystemVersionGreaterThanOrEqualTo9;

@end
