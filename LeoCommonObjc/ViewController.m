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
#import "LOTabPageVC.h"

@interface ViewController ()

@property (nonatomic, strong) LOPageVC *pageVC;
@property (nonatomic, strong) LOPageTabBar *tabBar;

@property (nonatomic, strong) LOTabPageVC *tabPageVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self testTabPageVC];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.pageVC.viewControllers = @[vc3, vc2, vc1];
    //        tabBar.tabs = [tabs subarrayWithRange:NSMakeRange(3, 7)];
    //    });
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)testTabPageVC {
    ItemVC *vc1 = [ItemVC new];
    vc1.view.backgroundColor = UIColor.redColor;
    vc1.name = @"OneVC";
    
    ItemVC *vc2 = [ItemVC new];
    vc2.view.backgroundColor = UIColor.greenColor;
    vc2.name = @"TwoVC";
    
    ItemVC *vc3 = [ItemVC new];
    vc3.view.backgroundColor = UIColor.blueColor;
    vc3.name = @"ThreeVC";
    
    self.tabPageVC = [[LOTabPageVC alloc] init];
    
    self.tabPageVC.pageTabBar.lineHeight = 2;
    self.tabPageVC.pageTabBar.lineMargin = 10;
    //    self.tabPageVC.pageTabBar.lineOffset = 2;
    self.tabPageVC.pageTabBar.lineColor = UIColor.darkGrayColor;
    
    NSMutableArray *tabModels = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"第%@个", @(i + 1)];
        NSAttributedString *title = [NSAttributedString string:name
                                                         color:[UIColor lightGrayColor]
                                                          font:[UIFont systemFontOfSize:15]];
        NSAttributedString *selectedTitle = [NSAttributedString string:name
                                                         color:[UIColor darkGrayColor]
                                                          font:[UIFont systemFontOfSize:15]];
        LOPageTabModel *model = [LOPageTabModel new];
        model.title = title;
        model.selectedTitle = selectedTitle;
        [tabModels addObject:model];
    }
    self.tabPageVC.tabModels = tabModels;
    
    self.tabPageVC.viewControllers = @[vc1, vc2, vc3];
    self.tabPageVC.selectedIndex = 0;
    self.tabPageVC.bounces = NO;
    self.tabPageVC.tabHeight = 44;
    self.tabPageVC.tabPadding = 10;
    
    [self addChildViewController:self.tabPageVC];
    [self.view addSubview:self.tabPageVC.view];
    [self.tabPageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
    [self.tabPageVC didMoveToParentViewController:self];
}

- (void)testPageVC {
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
    self.pageVC.bounces = NO;
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    [self.pageVC didMoveToParentViewController:self];
}

- (void)testPageTabBar {
    LOPageTab *tab1 = [[LOPageTab alloc] initWithTitle:[NSAttributedString string:@"商品"
                                                                            color:[UIColor lightGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                         selectedTitle:[NSAttributedString string:@"商品"
                                                                            color:[UIColor darkGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                               padding:10];
    
    LOPageTab *tab2 = [[LOPageTab alloc] initWithTitle:[NSAttributedString string:@"搭配"
                                                                            color:[UIColor lightGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                         selectedTitle:[NSAttributedString string:@"搭配"
                                                                            color:[UIColor darkGrayColor]
                                                                             font:[UIFont systemFontOfSize:15]]
                                               padding:10];
    
    LOPageTab *tab3 = [[LOPageTab alloc] initWithTitle:[NSAttributedString string:@"文章"
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
        LOPageTab *tab = [[LOPageTab alloc] initWithTitle:[NSAttributedString string:name
                                                                               color:[UIColor lightGrayColor]
                                                                                font:[UIFont systemFontOfSize:15]]
                                            selectedTitle:[NSAttributedString string:name
                                                                               color:[UIColor darkGrayColor]
                                                                                font:[UIFont systemFontOfSize:15]]
                                                  padding:10];
        [tabs addObject:tab];
    }
    
    
    self.tabBar = [[LOPageTabBar alloc] initWithFrame:CGRectZero
                                                 tabs:tabs
                                           lineHeight:2
                                           lineMargin:10
                                            lineColor:[UIColor darkGrayColor]];
    
    [self.view addSubview:self.tabBar];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(@20);
    }];
    self.tabBar.selectedIndex = 6;
}

@end
