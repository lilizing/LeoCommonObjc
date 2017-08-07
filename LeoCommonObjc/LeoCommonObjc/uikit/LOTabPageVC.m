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
#import "NSObject+RACPropertySubscribing+Ext.h"

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

- (void)setTabModels:(NSMutableArray<LOPageTabModel *> *)tabModels
     ViewControllers:(NSArray<UIViewController *> *)viewControllers
       selectedIndex:(NSInteger)selectedIndex {
    _tabModels = tabModels;
    NSMutableArray *tabs = [NSMutableArray array];
    [_tabModels enumerateObjectsUsingBlock:^(LOPageTabModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LOPageTab *tab = [[LOPageTab alloc] initWithTitle:obj.title selectedTitle:obj.selectedTitle padding:self.tabPadding];
        [tabs addObject:tab];
    }];
    [self.pageTabBar setTabs:tabs selectedIndex:selectedIndex];
    [self.pageViewController setViewControllers:viewControllers selectedIndex:selectedIndex];
    [self rebinding];
}

- (NSArray<UIViewController *> *)viewControllers {
    return self.pageViewController.viewControllers;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    self.pageViewController.viewControllers = viewControllers;
    [self rebinding];
}

- (void)setTabModels:(NSMutableArray<LOPageTabModel *> *)tabModels {
    _tabModels = tabModels;
    NSMutableArray *tabs = [NSMutableArray array];
    [_tabModels enumerateObjectsUsingBlock:^(LOPageTabModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LOPageTab *tab = [[LOPageTab alloc] initWithTitle:obj.title selectedTitle:obj.selectedTitle padding:self.tabPadding];
        [tabs addObject:tab];
    }];
    self.pageTabBar.tabs = tabs;
    [self rebinding];
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

- (BOOL)scrollEnabled {
    return self.pageViewController.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.pageViewController.scrollEnabled = scrollEnabled;
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
    [self rebinding];
}

- (void)insertWithViewController:(UIViewController *)viewController tabModel:(LOPageTabModel *)tabModel atIndex:(NSInteger)index {
    LOPageTab *tab = [[LOPageTab alloc] initWithTitle:tabModel.title selectedTitle:tabModel.selectedTitle padding:self.tabPadding];
    [self.pageTabBar insertTab:tab atIndex:index];
    [self.pageViewController insertViewController:viewController atIndex:index];
    [self rebinding];
}

-(void)removeAtIndex:(NSInteger)index {
    [self.pageTabBar removeTabAtIndex:index];
    [self.pageViewController removeViewControllerAtIndex:index];
    [self rebinding];
}

- (void)rebinding {
    @weakify(self)
    [[RACObserveOnce(self.pageTabBar, selectedIndex) distinctUntilChanged] subscribeNext:^(NSNumber *selectedIndex) {
        @strongify(self)
        self.pageViewController.selectedIndex = selectedIndex.integerValue;
    }];
    
    [[RACObserveOnce(self.pageViewController, selectedIndex) distinctUntilChanged] subscribeNext:^(NSNumber *selectedIndex) {
        @strongify(self)
        self.pageTabBar.selectedIndex = selectedIndex.integerValue;
    }];
}

@end
