#import "UIViewController+KeyboardScroll.h"
#import "Masonry.h"
#import "NSObject+Ext.h"
#import "NSObject+RAC+Ext.h"
#import "RACSignal+Ext.h"
#import "KeyboardState.h"

@implementation UIViewController (KeyboardScroll)

@dynamic keyboardScrollView;
- (UIScrollView *) keyboardScrollView {
    return GET_ASSOCIATED_OBJ();
}
- (void) setKeyboardScrollView:(UIScrollView *)keyboardScrollView {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(keyboardScrollView);
}

@dynamic keyboardContentView;
- (UIView *) keyboardContentView {
    return GET_ASSOCIATED_OBJ();
}
- (void) setKeyboardContentView:(UIView *)keyboardContentView {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(keyboardContentView);
}

- (void) setupKeyboardAutoScrollable {
    if (self.keyboardScrollView.superview) {
        return;
    }
    
    CGRect viewOrignalFrame = self.view.frame;
    
    self.keyboardContentView = self.view;
    
    UIView *view = [[UIView alloc] initWithFrame:self.keyboardContentView.frame];
    view.backgroundColor = self.keyboardContentView.backgroundColor;
    
    if (!self.keyboardScrollView) {
        self.keyboardScrollView = [[UIScrollView alloc] initWithFrame:view.frame];
    }
    self.keyboardScrollView.showsHorizontalScrollIndicator = NO;
    self.keyboardScrollView.backgroundColor = view.backgroundColor;
    self.keyboardScrollView.alwaysBounceVertical = YES;
    
    [view addSubview:self.keyboardScrollView];
    [self.keyboardScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self.keyboardScrollView addSubview:self.keyboardContentView];
    
    [self.keyboardContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.f);
        make.width.mas_equalTo(self.keyboardScrollView.mas_width);
        make.centerX.mas_equalTo(self.keyboardScrollView.mas_centerX);
        make.height.mas_equalTo(viewOrignalFrame.size.height);
    }];
    
    self.view = view;
    
    @weakify(self)
    
    [RACDealloc(KeyboardState.sharedState.willChangeFrameSignal) subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        
        self.keyboardScrollView.contentSize = self.keyboardContentView.frame.size;
        
        CGRect frame = [tuple[0] CGRectValue];
        frame = [self.view convertRect:frame fromView:nil];
        
        BOOL showingKeyboard = [KeyboardState isKeyboardShowing:frame];
        CGFloat yInset = showingKeyboard ? frame.size.height : 0;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        if ([self conformsToProtocol:@protocol(ScrollViewInsetsAdjust)]){
            id<ScrollViewInsetsAdjust> contentInsetsVC = (id<ScrollViewInsetsAdjust>) self;
            contentInsets = [contentInsetsVC scrollViewInsets];
        }else{
            contentInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, self.bottomLayoutGuide.length, 0.0);
        }
        
        contentInsets.bottom += yInset;
        self.keyboardScrollView.contentInset = contentInsets;
        self.keyboardScrollView.scrollIndicatorInsets = contentInsets;
    }];
}

@end
