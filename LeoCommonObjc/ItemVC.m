//
//  ItemVC.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/2.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "ItemVC.h"

@interface ItemVC ()

@end

@implementation ItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"[%@] - *将要显示*", self.name);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"[%@] - *显示*", self.name);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"[%@] - /将要消失/", self.name);
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"[%@] - /消失/", self.name);
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (parent) {
        NSLog(@"[%@] *将要添加*", self.name);
    } else {
        NSLog(@"[%@] /将要移除/", self.name);
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if (parent) {
        NSLog(@"[%@] *添加*", self.name);
    } else {
        NSLog(@"[%@] /移除/", self.name);
    }
}

@end
