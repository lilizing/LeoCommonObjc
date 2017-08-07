//
//  LOTabPageVC.h
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/3.
//  Copyright © 2017年 李理. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOPageVC.h"
#import "LOPageTabBar.h"

@interface LOTabPageVC : UIViewController

@property (nonatomic, strong, readonly) LOPageTabBar *pageTabBar;
@property (nonatomic, strong, readonly) LOPageVC *pageViewController;

@property (nonatomic, assign) CGFloat tabHeight;
@property (nonatomic, assign) CGFloat tabPadding;

@property (nonatomic, strong) NSMutableArray<LOPageTabModel *> *tabModels;

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL bounces;

@property (nonatomic, assign) BOOL scrollEnabled;

- (void)insertWithViewController:(UIViewController *)viewController
                        tabModel:(LOPageTabModel *)tabModel
                         atIndex:(NSInteger)index;

-(void)removeAtIndex:(NSInteger)index;

@end
