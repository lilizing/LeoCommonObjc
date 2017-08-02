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

@interface LOPageTab ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation LOPageTab

- (instancetype)initWithTitle:(NSAttributedString *)title
                selectedTitle:(NSAttributedString *)selectedTitle
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.title = title;
        self.selectedTitle = selectedTitle;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setAttributedTitle:self.title forState:UIControlStateNormal];
        [self.button setAttributedTitle:self.selectedTitle forState:UIControlStateSelected];
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (BOOL)isSelected {
    return self.button.isSelected;
}

- (void)setSelected:(BOOL)selected {
    [self.button setSelected:selected];
}


@end

@interface LOPageTabBar () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LOPageTab *selectedTab;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LOPageTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.lineOffset);
            make.left.equalTo(self.selectedTab).offset(self.lineMargin);
            make.right.equalTo(self.selectedTab).offset(-self.lineMargin);
            make.height.equalTo(@(self.lineHeight));
        }];
    }
    return _lineView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _scrollView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex || selectedIndex < 0 || selectedIndex > self.tabs.count - 1) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    [self.tabs enumerateObjectsUsingBlock:^(LOPageTab * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = idx == selectedIndex;
        if (obj.selected) {
            self.selectedTab = obj;
        }
    }];
    
    CGFloat contentOffsetX = 0;
    if (self.scrollView.contentSize.width > self.width) {
        contentOffsetX = MIN(MAX(self.selectedTab.centerX - self.width / 2, 0), self.scrollView.contentSize.width - self.width);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-self.lineOffset);
            make.left.equalTo(self.selectedTab).offset(self.lineMargin);
            make.right.equalTo(self.selectedTab).offset(-self.lineMargin);
            make.height.equalTo(@(self.lineHeight));
        }];
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end
