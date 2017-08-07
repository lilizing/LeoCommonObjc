//
//  LOPageTabBar.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/2.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "LOPageTabBar.h"
#import <Masonry/Masonry.h>
#import "NSObject+Ext.h"
#import "UIView+Ext.h"
#import "UIButton+RACCommandSupport+Ext.h"
#import "UIButton+Ext.h"
#import "NSAttributedString+size.h"
#import "NSAttributedString+Ext.h"
#import "RACDisposableSubscriptingAssignmentTrampoline.h"

@implementation LOPageTabModel

@end

@interface LOPageTab ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation LOPageTab

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSAttributedString *)title
                selectedTitle:(NSAttributedString *)selectedTitle
                      padding:(CGFloat)padding {
    self = [super initWithFrame:frame];
    if (self) {
        _model = [LOPageTabModel new];
        self.model.title = title;
        self.model.selectedTitle = selectedTitle;
        self.padding = padding;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.userInteractionEnabled = NO;
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.button setAttributedTitle:self.model.title forState:UIControlStateNormal];
        [self.button setAttributedTitle:self.model.selectedTitle forState:UIControlStateSelected];
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSAttributedString *)title
                selectedTitle:(NSAttributedString *)selectedTitle
                      padding:(CGFloat)padding {
    return [self initWithFrame:CGRectZero title:title selectedTitle:selectedTitle padding:padding];
}

- (BOOL)isSelected {
    return self.button.isSelected;
}

- (void)setSelected:(BOOL)selected {
    [self.button setSelected:selected];
}

- (CGSize)size {
    UILabel *label = [UILabel new];
    label.attributedText = self.model.title;
    label.numberOfLines = 1;
    CGSize size1 = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.height)];

    label.attributedText = self.model.selectedTitle;
    CGSize size2 = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.height)];
    //以下计算方式不准确，总差那么几个像素
    //    CGSize size1 = [NSAttributedString getExactSizeOfAttributedStr:self.model.title withConstraints:CGSizeMake(CGFLOAT_MAX, self.height) limitedToNumberOfLines:1];
    //    CGSize size2 = [NSAttributedString getExactSizeOfAttributedStr:self.model.selectedTitle withConstraints:CGSizeMake(CGFLOAT_MAX, self.height) limitedToNumberOfLines:1];
    return CGSizeMake(MAX(size1.width, size2.width) + self.padding * 2, MAX(self.height, MAX(size1.height, size2.height)));
}

@end

@interface LOPageTabBar () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LOPageTab *selectedTab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation LOPageTabBar

- (instancetype)initWithFrame:(CGRect)frame
                         tabs:(NSMutableArray<LOPageTab *> *)tabs
                   lineHeight:(CGFloat)lineHeight
                   lineMargin:(CGFloat)lineMargin
                    lineColor:(UIColor *)lineColor {
    self = [self initWithFrame:frame];
    if (self) {
        _tabs = tabs;
        _lineHeight = lineHeight;
        _lineColor = lineColor;
        _lineMargin = lineMargin;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self resetSelected];
        [self rebinding];
    }
    return self;
}

- (instancetype)initWithTabs:(NSArray<LOPageTab *> *)tabs
                   lineHeight:(CGFloat)lineHeight
                   lineMargin:(CGFloat)lineMargin
                    lineColor:(UIColor *)lineColor {
    return [self initWithFrame:CGRectZero tabs:tabs lineHeight:lineHeight lineMargin:lineMargin lineColor:lineColor];
}

- (void)initSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _lineView = [[UIView alloc] init];
    [self.scrollView addSubview:_lineView];
    
    _seperatorView = [[UIView alloc] init];
    [self addSubview:_seperatorView];
}

- (void)setTabs:(NSMutableArray<LOPageTab *> *)tabs {
    for (LOPageTab *tab in _tabs) {
        [tab removeFromSuperview];
    }
    _tabs = tabs;
    
    _selectedIndex = 0;
    
    [self resetSelected];
    
    [self rebinding];
    
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [self relayoutScrollview];
            [self relayoutTabsView];
            [self relayoutLineView];
            [self layoutIfNeeded];
        } completion:nil];
    }
}

- (void)insertTab:(LOPageTab *)tab atIndex:(NSInteger)index {
    if (index < 0 || index > self.tabs.count - 1) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabs];
    [array insertObject:tab atIndex:index];
    _tabs = array;
    
    if (index <= _selectedIndex) {
        _selectedIndex += 1;
    }
    [self resetSelected];
    
    [self rebinding];
    
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [self relayoutScrollview];
            [self relayoutTabsView];
            [self relayoutLineView];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)removeTabAtIndex:(NSInteger)index {
    if (index < 0 || index > self.tabs.count - 1) {
        return;
    }
    
    LOPageTab *tab = self.tabs[index];
    tab.hidden = YES;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tabs];
    [array removeObjectAtIndex:index];
    _tabs = array;
    
    if (index <= _selectedIndex) {
        _selectedIndex -= 1;
    }
    [self resetSelected];
    
    [self rebinding];
    
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [self relayoutScrollview];
            [self relayoutTabsView];
            [self relayoutLineView];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [tab removeFromSuperview];
        }];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == NSNotFound
        || _selectedIndex == selectedIndex
        || selectedIndex < 0
        || selectedIndex > self.tabs.count - 1) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    [self resetSelected];
    
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [self relayoutScrollview];
            [self relayoutLineView];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)rebinding {
    @weakify(self)
    RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
    [self.tabs enumerateObjectsUsingBlock:^(LOPageTab * _Nonnull tab, NSUInteger idx, BOOL * _Nonnull stop) {
        [disposable addDisposable:[tab.rac_signalForTap subscribeNext:^(id x) {
            @strongify(self)
            self.selectedIndex = idx;
        }]];
    }];
    RACDisposable(self, selecteTabDisposable) = disposable;
}

- (void)resetSelected {
    [self.tabs enumerateObjectsUsingBlock:^(LOPageTab * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = idx == _selectedIndex;
        if (obj.selected) {
            self.selectedTab = obj;
            self.selectedTab.selected = YES;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self relayoutScrollview];
    [self relayoutTabsView];
    [self relayoutLineView];
    [self.scrollView bringSubviewToFront:_lineView];
}

- (void)relayoutLineView {
    self.lineView.backgroundColor = self.lineColor;
    self.seperatorView.backgroundColor = self.seperatorLineColor;
    if (self.selectedTab) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.lineOffset-self.seperatorLineHeight);
            make.left.equalTo(self.selectedTab).offset(self.lineMargin + self.selectedTab.padding);
            make.right.equalTo(self.selectedTab).offset(-(self.lineMargin + self.selectedTab.padding));
            make.height.equalTo(@(self.lineHeight));
        }];
    } else {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.lineOffset-self.seperatorLineHeight);
            make.height.equalTo(@(self.lineHeight));
            make.width.equalTo(@0);
        }];
    }
    [self.seperatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(self.seperatorLineHeight));
    }];
}

- (void)relayoutScrollview {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat width = 0;
    for (LOPageTab *tab in self.tabs) {
        width += [tab size].width;
    }
    self.scrollView.contentSize = CGSizeMake(MAX(width, self.width), 0);
    
    CGFloat contentOffsetX = 0;
    if (self.scrollView.contentSize.width > self.width) {
        contentOffsetX = MIN(MAX(self.selectedTab.centerX - self.width / 2, 0), self.scrollView.contentSize.width - self.width);
    }
    self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
}

- (void)relayoutTabsView {
    CGFloat width = 0;
    for (LOPageTab *tab in self.tabs) {
        width += [tab size].width;
    }
    CGFloat tabMargin = 0;
    if (width < self.width) {
        tabMargin = (self.width - width) / MAX(1, self.tabs.count * 2);
    }
    [self.tabs enumerateObjectsUsingBlock:^(LOPageTab * _Nonnull tab, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!tab.superview) {
            [self.scrollView addSubview:tab];
        }
        LOPageTab *preTab = idx > 0 ? _tabs[idx - 1] : nil;
        CGSize size = [tab size];
        [tab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.scrollView);
            make.width.equalTo(@(size.width));
            make.left.equalTo(preTab ? preTab.mas_right : @(0)).offset(preTab ? tabMargin * 2 : tabMargin);
        }];
    }];
}

@end
