#import "KeyboardState.h"

@interface KeyboardState()

@property (nonatomic, strong) RACSubject *willChangeFrameSignal;
@property (nonatomic, strong) RACSubject *didChangeFrameSignal;
@property (nonatomic, strong) RACSubject *willShowSignal;

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) CGFloat latestNoneZeroKeyboardHeight;

@end

@implementation KeyboardState

#pragma mark - private methods

- (RACTuple *) _keyboardTupleFromNotification:(NSNotification *)note {
    id frame = note.userInfo[UIKeyboardFrameEndUserInfoKey];
    id duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    id curve = note.userInfo[UIKeyboardAnimationCurveUserInfoKey];

    return RACTuplePack(frame, duration, curve);
}

#pragma mark -

@dynamic keyboardShowing;
- (BOOL) isKeyboardShowing {
    return [KeyboardState isKeyboardShowing:self.keyboardFrame];
}

@synthesize keyboardFrame = _keyboardFrame;
- (void)setKeyboardFrame:(CGRect)keyboardFrame {
    _keyboardFrame = keyboardFrame;

    if (fLargerThan(CGRectGetHeight(keyboardFrame), 0.f)) {
        self.latestNoneZeroKeyboardHeight = CGRectGetHeight(keyboardFrame);
    }
}

IMP_SINGLETON(sharedState, KeyboardState)

- (id) init {
    if (self = [super init]) {
        self.willChangeFrameSignal = [RACSubject subject];
        self.didChangeFrameSignal = [RACSubject subject];
        self.willShowSignal = [RACSubject subject];

        // keyboard is hidden initially.
        self.keyboardFrame = CGRectMake(0.f,
                [UIScreen mainScreen].bounds.size.height,
                [UIScreen mainScreen].bounds.size.width,
                0.f);
    }
    return self;
}

- (void) startMonitoring {
    if (RACDisposable(self, keyboardDisposable)) {
        return;
    }
    
    @weakify(self)

    RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];

    [disposable addDisposable:[[self observeNotification:UIKeyboardWillChangeFrameNotification] subscribeNext:^(NSNotification *note) {
        @strongify(self)

        [self willChangeValueForKey:@"keyboardShowing"];
        self.keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [self didChangeValueForKey:@"keyboardShowing"];

        [self.willChangeFrameSignal sendNext:[self _keyboardTupleFromNotification:note]];
    }]];

    [disposable addDisposable:[[self observeNotification:UIKeyboardDidChangeFrameNotification] subscribeNext:^(NSNotification *note) {
        @strongify(self)

        [self willChangeValueForKey:@"keyboardShowing"];
        self.keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [self didChangeValueForKey:@"keyboardShowing"];

        [self.didChangeFrameSignal sendNext:[self _keyboardTupleFromNotification:note]];
    }]];
    
    [disposable addDisposable:[[self observeNotification:UIKeyboardWillShowNotification] subscribeNext:^(NSNotification *note) {
        @strongify(self)
        
        [self.willShowSignal sendNext:[self _keyboardTupleFromNotification:note]];
    }]];

    RACDisposable(self, keyboardDisposable) = disposable;
}

- (void) stopMonitoring {
    if (!RACDisposable(self, keyboardDisposable)) {
        return;
    }

    RACDisposable(self, keyboardDisposable) = nil;
}

+ (BOOL) isKeyboardShowing:(CGRect)frame {
    return !fEqualTo(frame.origin.y, 0.f) && fLessThan(frame.origin.y, [UIApplication sharedApplication].keyWindow.frame.size.height);
}

@end
