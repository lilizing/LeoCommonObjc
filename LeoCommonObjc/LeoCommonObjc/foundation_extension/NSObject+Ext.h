#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define GET_ASSOCIATED_OBJ() objc_getAssociatedObject(self, _cmd)

#define _SET_ASSOCIATED_OBJ_OPT(obj, opt)           objc_setAssociatedObject(self, @selector(obj), (obj), (opt))
#define SET_ASSOCIATED_OBJ_ASSIGN(obj)              _SET_ASSOCIATED_OBJ_OPT(obj, OBJC_ASSOCIATION_ASSIGN)
#define SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(obj)    _SET_ASSOCIATED_OBJ_OPT(obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define SET_ASSOCIATED_OBJ_COPY_NONATOMIC(obj)      _SET_ASSOCIATED_OBJ_OPT(obj, OBJC_ASSOCIATION_COPY_NONATOMIC)
#define SET_ASSOCIATED_OBJ_RETAIN(obj)              _SET_ASSOCIATED_OBJ_OPT(obj, OBJC_ASSOCIATION_RETAIN)
#define SET_ASSOCIATED_OBJ_COPY(obj)                _SET_ASSOCIATED_OBJ_OPT(obj, OBJC_ASSOCIATION_COPY)

#pragma mark -

#define DEF_SINGLETON(methodName) \
+ (instancetype)methodName;

#define DEF_SINGLETON_W_CLASS(methodName, class) \
+ (class *)methodName;

#define BEGIN_IMP_SINGLETON(methodName, class) \
+ (class *)methodName { \
    static class *instance = nil; \
    static dispatch_once_t once; \
    dispatch_once(&once, ^{ \

#define END_IMP_SINGLETON \
    }); \
    return instance; \
}

#define IMP_SINGLETON(methodName, class) \
BEGIN_IMP_SINGLETON(methodName, class) \
    instance = [[self alloc] init]; \
END_IMP_SINGLETON

#define NO_OP ((void)0);

#pragma mark -

#define BEGIN_LAZY_PROP(propertyName, class)\
- (class *) propertyName {\
    class *propertyName = GET_ASSOCIATED_OBJ();\
    if (!propertyName) {

#define END_LAZY_PROP(propertyName)\
        SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(propertyName);\
    }\
    return propertyName;\
}

#pragma mark -

#define fEqualTo(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fEqualToZero(a) (fabs(a) < FLT_EPSILON)
#define fLessThan(a,b) (!fEqualTo(a, b) && (a) < (b))
#define fLessThanOrEqualTo(a,b) (fEqualTo(a, b) || (a) < (b))
#define fLargerThan(a,b) (!fEqualTo(a, b) && (a) > (b))
#define fLargerThanOrEqualTo(a,b) (fEqualTo(a, b) || (a) > (b))

@interface NSObject(Ext)

/*
 * Return object properties' name and value in JSON format
 */
- (NSString *)propertiesDescription;
- (BOOL)isPropertiesEqual:(NSObject *)obj;

/**
 * Copy from Three20
 * Additional performSelector signatures that support up to 7 arguments.
 */
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5 withObject:(id)p6;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7;

+ (void) methodSwizzleInstanceSelector:(SEL)selector0
                          withSelector:(SEL)selector1;

+ (void) methodSwizzleClassSelector:(SEL)selector0
                       withSelector:(SEL)selector1;

- (void) notifyValueChangeForKey:(NSString *) key;

@end
