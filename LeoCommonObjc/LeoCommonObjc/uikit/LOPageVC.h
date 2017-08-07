//
//  LOPageVC.h
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/1.
//  Copyright © 2017年 李理. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOPageVC : UIViewController

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) BOOL scrollEnabled;

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

- (void)removeViewControllerAtIndex:(NSInteger)index;

@end
