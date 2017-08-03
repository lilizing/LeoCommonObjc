//
//  LOTabPageVC.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/3.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "LOTabPageVC.h"
#import <Masonry/Masonry.h>
#import "NSObject+Ext.h"
#import "UIView+Ext.h"
#import "NSObject+RAC+Ext.h"
#import "RACDisposableSubscriptingAssignmentTrampoline.h"
#import "RACSignal+Ext.h"

@interface LOTabPageVC ()

@end

@implementation LOTabPageVC

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageTabBar = [[LOPageTabBar alloc] init];
        _pageViewController = [[LOPageVC alloc] init];
    }
    return self;
}

- (NSArray<UIViewController *> *)viewControllers {
    return self.pageViewController.viewControllers;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    self.pageViewController.viewControllers = viewControllers;
}

- (void)setTabModels:(NSMutableArray<LOPageTabModel *> *)tabModels {
    _tabModels = tabModels;
    NSMutableArray *tabs = [NSMutableArray array];
    [_tabModels enumerateObjectsUsingBlock:^(LOPageTabModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LOPageTab *tab = [[LOPageTab alloc] initWithTitle:obj.title selectedTitle:obj.selectedTitle padding:self.tabPadding];
        [tabs addObject:tab];
    }];
    self.pageTabBar.tabs = tabs;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.pageViewController.selectedIndex = selectedIndex;
    self.pageTabBar.selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex {
    return self.pageViewController.selectedIndex;
}

- (void)setBounces:(BOOL)bounces {
    self.pageViewController.bounces = bounces;
}

- (BOOL)bounces {
    return self.pageViewController.bounces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (LOPageTab *tab in self.pageTabBar.tabs) {
        tab.padding = self.tabPadding;
    }
    [self.view addSubview:self.pageTabBar];
    [self.pageTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(self.tabHeight));
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.pageTabBar.mas_bottom);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self binding];
}

- (void)binding {
    @weakify(self)
    [[RACObserve(self.pageTabBar, selectedIndex) distinctUntilChanged] subscribeNext:^(NSNumber *selectedIndex) {
        @strongify(self)
        self.pageViewController.selectedIndex = selectedIndex.integerValue;
    }];
    
    [[RACObserve(self.pageViewController, selectedIndex) distinctUntilChanged] subscribeNext:^(NSNumber *selectedIndex) {
        @strongify(self)
        self.pageTabBar.selectedIndex = selectedIndex.integerValue;
    }];
}

@end
