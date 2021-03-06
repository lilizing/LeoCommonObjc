//
//  LOPageVC.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/1.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "LOPageVC.h"
#import <Masonry/Masonry.h>
#import "NSObject+Ext.h"

@interface LOPageVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIViewController *selectedViewController;

@property (nonatomic, assign) NSInteger toIndex;

@property (nonatomic, assign, getter=isMoving) NSInteger moving;

@end

@implementation LOPageVC

- (void)relayoutViewControllers:(BOOL)animated {
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.view.superview) {
            [obj.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.mas_top);
                make.bottom.equalTo(self.scrollView.mas_bottom);
                make.left.equalTo(self.scrollView.mas_left).offset(idx * self.scrollView.bounds.size.width);
                make.width.equalTo(self.scrollView.mas_width);
                make.height.equalTo(self.scrollView.mas_height);
            }];
        }
    }];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * self.viewControllers.count, self.scrollView.bounds.size.height);
    //fuck,这里纯粹是为了解决iOS8的系统bug，做个0秒延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * self.selectedIndex, 0) animated:animated];
    });
}

- (void)resetSelectedViewController {
    if (self.viewControllers.count) {
        UIViewController *selectedViewController = self.viewControllers[self.selectedIndex];
        if (self.selectedViewController != selectedViewController) {
            [self addChildViewController:selectedViewController];
            [self.scrollView addSubview:selectedViewController.view];
            [selectedViewController didMoveToParentViewController:self];
            
            if (self.selectedViewController) {
                [self.selectedViewController beginAppearanceTransition:NO animated:YES];
                [selectedViewController beginAppearanceTransition:YES animated:YES];
                
                [self.selectedViewController endAppearanceTransition];
                [selectedViewController endAppearanceTransition];
            }
            
            self.selectedViewController = selectedViewController;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toIndex = -1;
    [self resetSelectedViewController];
    [self relayoutViewControllers:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self relayoutViewControllers:NO];
    [self.selectedViewController beginAppearanceTransition:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self relayoutViewControllers:NO];
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.selectedViewController beginAppearanceTransition:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.selectedViewController endAppearanceTransition];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    [self setViewControllers:viewControllers selectedIndex:0];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers selectedIndex:(NSInteger)selectedIndex {
    for (UIViewController *vc in _viewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    _viewControllers = viewControllers;
    _selectedIndex = selectedIndex;
    [self resetSelectedViewController];
    [self relayoutViewControllers:NO];
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (index == NSNotFound || index < 0 || index > self.viewControllers.count - 1) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewControllers];
    [array insertObject:viewController atIndex:index];
    _viewControllers = array;
    
    if (index <= _selectedIndex) {
        _selectedIndex += 1;
    }

    [self relayoutViewControllers:NO];
}

- (void)removeViewControllerAtIndex:(NSInteger)index {
    if (index == NSNotFound || index < 0 || index > self.viewControllers.count - 1) {
        return;
    }
    
    UIViewController *vc = self.viewControllers[index];
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewControllers];
    [array removeObjectAtIndex:index];
    _viewControllers = array;
    
    if (index <= _selectedIndex) {
        _selectedIndex -= 1;
        [self resetSelectedViewController];
    }
    [self relayoutViewControllers:NO];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _scrollView;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex || selectedIndex < 0 || selectedIndex > self.viewControllers.count - 1) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self resetSelectedViewController];
    [self relayoutViewControllers:NO];
}

- (BOOL)bounces {
    return self.scrollView.bounces;
}

- (void)setBounces:(BOOL)bounces {
    self.scrollView.bounces = bounces;
}

- (BOOL)scrollEnabled {
    return self.scrollView.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.scrollView.scrollEnabled = scrollEnabled;
}

- (void)startMoving:(NSInteger)index {
    self.moving = YES;
    
    self.selectedViewController = self.viewControllers[self.selectedIndex];
    UIViewController *toViewController = self.viewControllers[self.toIndex];
    
    if (!toViewController.view.superview) {
        [self addChildViewController:toViewController];
        
        [self.scrollView addSubview:toViewController.view];
        [toViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.left.equalTo(self.scrollView.mas_left).offset(index * self.scrollView.bounds.size.width);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(self.scrollView.mas_height);
        }];
        
        [toViewController didMoveToParentViewController:self];
    }
    [self.selectedViewController beginAppearanceTransition:NO animated:YES];
    [toViewController beginAppearanceTransition:YES animated:YES];
}

- (void)endMoving {
    if (!self.isMoving) {
        return;
    }
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat contentWidth = self.scrollView.bounds.size.width;
    
    UIViewController *toViewController = self.viewControllers[self.toIndex];
    
    if (self.toIndex > self.selectedIndex) {
        if (fLargerThanOrEqualTo(offsetX, self.toIndex * contentWidth)) {
            
            LOLog(@"[翻页 - 向右] - 成功");
            
            [self.selectedViewController endAppearanceTransition];
            [toViewController endAppearanceTransition];
            
            self.selectedViewController = toViewController;
            self.selectedIndex = self.toIndex;
        } else { //回弹
            
            LOLog(@"[翻页 - 向右] - 失败，回弹");
            
            [self.selectedViewController endAppearanceTransition];
            [toViewController endAppearanceTransition];
            
            [toViewController beginAppearanceTransition:NO animated:YES];
            [self.selectedViewController beginAppearanceTransition:YES animated:YES];
            
            [toViewController endAppearanceTransition];
            [self.selectedViewController endAppearanceTransition];
        }
    } else {
        if (fLessThanOrEqualTo(offsetX, self.toIndex * contentWidth)) {
            
            LOLog(@"[翻页 - 向左] - 成功");
            
            [self.selectedViewController endAppearanceTransition];
            [toViewController endAppearanceTransition];
            
            self.selectedViewController = toViewController;
            self.selectedIndex = self.toIndex;
        } else { //回弹
        
            LOLog(@"[翻页 - 向左] - 失败，回弹");
            
            [self.selectedViewController endAppearanceTransition];
            [toViewController endAppearanceTransition];
            
            [toViewController beginAppearanceTransition:NO animated:YES];
            [self.selectedViewController beginAppearanceTransition:YES animated:YES];
            
            [toViewController endAppearanceTransition];
            [self.selectedViewController endAppearanceTransition];
        }
    }
    
    self.toIndex = -1;
    self.moving = NO;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat contentWidth = self.scrollView.bounds.size.width;
    if (offsetX < 0 || offsetX > (self.viewControllers.count - 1) * contentWidth) {
        return;
    }
    if (self.toIndex > -1) {
        return;
    }
    
    if (fLargerThanOrEqualTo(offsetX, self.selectedIndex * contentWidth)) {
        self.toIndex = self.selectedIndex + 1;
    } else {
        self.toIndex = self.selectedIndex - 1;
    }
    if (self.toIndex > -1 && self.toIndex < self.viewControllers.count) {
        [self startMoving:self.toIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self endMoving];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endMoving];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self endMoving];
}

#pragma mark - 解除对子视图控制器自动生命周期管理
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
    return NO;
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    return NO;
}

@end
