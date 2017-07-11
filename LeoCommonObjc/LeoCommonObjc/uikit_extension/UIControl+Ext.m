#import "UIControl+Ext.h"
#import "NSObject+Ext.h"

@implementation UIControl(Ext)

@dynamic info;
- (id) info {
    return GET_ASSOCIATED_OBJ();
}

- (void) setInfo:(id)info {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(info);
}

@end
