#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSObject+Ext.h"
#import "NSObject+RAC+Ext.h"
#import "RACDisposableSubscriptingAssignmentTrampoline.h"

@interface KeyboardState : NSObject

@property (nonatomic, readonly) RACSubject *willChangeFrameSignal;
@property (nonatomic, readonly) RACSubject *didChangeFrameSignal;
@property (nonatomic, readonly) RACSubject *willShowSignal;

@property (nonatomic, readonly) CGRect keyboardFrame;
@property (nonatomic, readonly, getter=isKeyboardShowing) BOOL keyboardShowing;
@property (nonatomic, assign, readonly) CGFloat latestNoneZeroKeyboardHeight;

DEF_SINGLETON(sharedState)

- (void) startMonitoring;
- (void) stopMonitoring;

+ (BOOL) isKeyboardShowing:(CGRect)frame;

@end
