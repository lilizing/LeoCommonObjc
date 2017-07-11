#import "UIViewController+KeyboardScroll.h"
#import "Masonry.h"
#import "NSObject+Ext.h"
#import "NSObject+RAC+Ext.h"
#import "RACSignal+Ext.h"
#import "KeyboardState.h"

@implementation UIViewController (KeyboardScroll)

@dynamic scrollView;
- (UIScrollView *) scrollView {
    return GET_ASSOCIATED_OBJ();
}
- (void) setScrollView:(UIScrollView *)scrollView {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(scrollView);
}

@dynamic contentView;
- (UIView *) contentView {
    return GET_ASSOCIATED_OBJ();
}
- (void) setContentView:(UIView *)contentView {
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(contentView);
}

- (void) setupKeyboardAutoScrollable {
    if (self.scrollView.superview) {
        return;
    }
    
    CGRect viewOrignalFrame = self.view.frame;
    
    self.contentView = self.view;
    
    UIView *view = [[UIView alloc] initWithFrame:self.contentView.frame];
    view.backgroundColor = self.contentView.backgroundColor;
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:view.frame];
    }
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = view.backgroundColor;
    self.scrollView.alwaysBounceVertical = YES;
    
    [view addSubview:self.scrollView];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.f);
        make.width.mas_equalTo(self.scrollView.mas_width);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.height.mas_equalTo(viewOrignalFrame.size.height);
    }];
    
    self.view = view;
    
    @weakify(self)
    
    [RACDealloc(KeyboardState.sharedState.willChangeFrameSignal) subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        
        self.scrollView.contentSize = self.contentView.frame.size;
        
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
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

@end
