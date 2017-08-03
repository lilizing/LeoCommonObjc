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
#import "LOPageTabBar.h"
#import "NSAttributedString+Ext.h"

@interface ViewController ()

@property (nonatomic, strong) LOPageVC *pageVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    LOPageTab *tab1 = [[LOPageTab alloc] initWithFrame:CGRectMake(0, 0, 0, 44)
                                                 Title:[NSAttributedString string:@"商品"
                                                                            color:[UIColor lightGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                         selectedTitle:[NSAttributedString string:@"商品"
                                                                            color:[UIColor darkGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                               padding:10];
    
    LOPageTab *tab2 = [[LOPageTab alloc] initWithFrame:CGRectMake(0, 0, 0, 44)
                                                 Title:[NSAttributedString string:@"搭配"
                                                                            color:[UIColor lightGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                         selectedTitle:[NSAttributedString string:@"搭配"
                                                                            color:[UIColor darkGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                               padding:10];
    
    LOPageTab *tab3 = [[LOPageTab alloc] initWithFrame:CGRectMake(0, 0, 0, 44)
                                                 Title:[NSAttributedString string:@"文章"
                                                                            color:[UIColor lightGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                         selectedTitle:[NSAttributedString string:@"文章"
                                                                            color:[UIColor darkGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                               padding:10];
    
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:tab1];
    [tabs addObject:tab2];
    [tabs addObject:tab3];
    
    for (int i = 3; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"第%@个", @(i + 1)];
        LOPageTab *tab = [[LOPageTab alloc] initWithFrame:CGRectMake(0, 0, 0, 44)
                                                     Title:[NSAttributedString string:name
                                                                                color:[UIColor lightGrayColor]
                                                                                 font:[UIFont systemFontOfSize:15]]
                                             selectedTitle:[NSAttributedString string:name
                                                                                color:[UIColor darkGrayColor]
                                                                                 font:[UIFont systemFontOfSize:15]]
                                                   padding:10];
        [tabs addObject:tab];
    }
    
    
    LOPageTabBar *tabBar = [[LOPageTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)
                                                          tabs:tabs
                                                    lineHeight:2
                                                    lineMargin:10
                                                     lineColor:[UIColor darkGrayColor]];
    
    [self.view addSubview:tabBar];
    [tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(@20);
    }];
    
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
    self.pageVC.selectedIndex = 0;
    self.pageVC.bounces = YES;
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    [self.pageVC didMoveToParentViewController:self];
    
    
}

@end
