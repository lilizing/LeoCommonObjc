//
//  ViewController.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/6/26.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIButton+RACCommandSupport+Ext.h"
#import "UIView+Ext.h"
#import "LOPageVC.h"
#import <Masonry/Masonry.h>
#import "ItemVC.h"

@interface ViewController ()

@property (nonatomic, strong) LOPageVC *pageVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ItemVC *vc1 = [ItemVC new];
    vc1.view.backgroundColor = UIColor.redColor;
    vc1.name = @"OneVC";
    
    ItemVC *vc2 = [ItemVC new];
    vc2.view.backgroundColor = UIColor.greenColor;
    vc2.name = @"TwoVC";
    
    ItemVC *vc3 = [ItemVC new];
    vc3.view.backgroundColor = UIColor.blueColor;
    vc3.name = @"ThreeVC";
    
    self.pageVC = [[LOPageVC alloc] init];
    self.pageVC.viewControllers = @[vc1, vc2, vc3];
    self.pageVC.selectedIndex = 1;
    self.pageVC.bounces = YES;
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageVC didMoveToParentViewController:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageVC.selectedIndex = 0;
    });
}

@end
