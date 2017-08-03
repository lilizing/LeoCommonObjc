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

@interface LOPageTab ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation LOPageTab

- (instancetype)initWithFrame:(CGRect)frame
                        Title:(NSAttributedString *)title
                selectedTitle:(NSAttributedString *)selectedTitle
                      padding:(CGFloat)padding {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.selectedTitle = selectedTitle;
        self.padding = padding;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.userInteractionEnabled = NO;
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.button setAttributedTitle:self.title forState:UIControlStateNormal];
        [self.button setAttributedTitle:self.selectedTitle forState:UIControlStateSelected];
        
    }
    return self;
}

- (BOOL)isSelected {
    return self.button.isSelected;
}

- (void)setSelected:(BOOL)selected {
    [self.button setSelected:selected];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize size1 = [NSAttributedString getExactSizeOfAttributedStr:self.title withConstraints:CGSizeMake(CGFLOAT_MAX, self.height) limitedToNumberOfLines:1];
    CGSize size2 = [NSAttributedString getExactSizeOfAttributedStr:self.selectedTitle withConstraints:CGSizeMake(CGFLOAT_MAX, self.height) limitedToNumberOfLines:1];
    return CGSizeMake(MAX(size1.width, size2.width) + self.padding * 2, self.height);
}

@end

@interface LOPageTabBar () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LOPageTab *selectedTab;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LOPageTabBar

- (instancetype)initWithFrame:(CGRect)frame
                         tabs:(NSArray<LOPageTab *> *)tabs
                   lineHeight:(CGFloat)lineHeight
                   lineMargin:(CGFloat)lineMargin
                    lineColor:(UIColor *)lineColor {
    self = [super initWithFrame:frame];
    if (self) {
        _tabs = tabs;
        _lineHeight = lineHeight;
        _lineColor = lineColor;
        _lineMargin = lineMargin;
        
        [self initSubviews];
        [self relayout];
        [self rebinding];
    }
    return self;
}

- (void)initSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = _lineColor;
    [self.scrollView addSubview:_lineView];
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

- (void)setTabs:(NSArray<LOPageTab *> *)tabs {
    for (LOPageTab *tab in _tabs) {
        [tab removeFromSuperview];
    }
    _tabs = tabs;
    [self relayout];
    [self rebinding];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == NSNotFound
        || _selectedIndex == selectedIndex
        || selectedIndex < 0
        || selectedIndex > self.tabs.count - 1) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    [self.tabs enumerateObjectsUsingBlock:^(LOPageTab * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = idx == selectedIndex;
        if (obj.selected) {
            self.selectedTab = obj;
            self.selectedTab.selected = YES;
        }
    }];
    
    CGFloat contentOffsetX = 0;
    if (self.scrollView.contentSize.width > self.width) {
        contentOffsetX = MIN(MAX(self.selectedTab.centerX - self.width / 2, 0), self.scrollView.contentSize.width - self.width);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
        [self relayoutLineView];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)relayout {
    _selectedIndex = 0;
    if (self.tabs.count) {
        self.selectedTab = self.tabs[self.selectedIndex];
        self.selectedTab.selected = YES;
    }
    [self relayoutScrollview];
    [self relayoutTabsView];
    [self relayoutLineView];
    [self.scrollView bringSubviewToFront:_lineView];
}

- (void)relayoutLineView {
    if (self.selectedTab) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.lineOffset);
            make.left.equalTo(self.selectedTab).offset(self.lineMargin + self.selectedTab.padding);
            make.right.equalTo(self.selectedTab).offset(-(self.lineMargin + self.selectedTab.padding));
            make.height.equalTo(@(self.lineHeight));
        }];
    } else {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.lineOffset);
            make.height.equalTo(@(self.lineHeight));
            make.width.equalTo(@0);
        }];
    }
}

- (void)relayoutScrollview {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    CGFloat width = 0;
    for (LOPageTab *tab in self.tabs) {
        width += [tab sizeThatFits:CGSizeMake(self.width, self.height)].width;
    }
    self.scrollView.contentSize = CGSizeMake(MAX(width, self.width), 0);
}

- (void)relayoutTabsView {
    CGFloat width = 0;
    for (LOPageTab *tab in self.tabs) {
        width += [tab sizeThatFits:CGSizeMake(self.width, self.height)].width;
    }
    CGFloat tabMargin = 0;
    if (width < self.width) {
        tabMargin = (self.width - width) / MAX(1, self.tabs.count + 1);
    }
    [self.tabs enumerateObjectsUsingBlock:^(LOPageTab * _Nonnull tab, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!tab.superview) {
            [self.scrollView addSubview:tab];
        }
        LOPageTab *preTab = idx > 0 ? _tabs[idx - 1] : nil;
        CGSize size = [tab sizeThatFits:CGSizeMake(self.width, self.height)];
        [tab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.scrollView);
            make.width.equalTo(@(size.width));
            make.left.equalTo(preTab ? preTab.mas_right : @(0)).offset(tabMargin);
        }];
    }];
}

@end
