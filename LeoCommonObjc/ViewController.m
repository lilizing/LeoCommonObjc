//
//  ViewController.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/6/26.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface Person : NSObject

@property(nonatomic, copy) NSString *name;

@end

@implementation Person

-(void)sayHello {
    NSLog(@"Hello %@", self.name);
}

-(void)dealloc {
    NSLog(@"Person 释放");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@"Hello"];
    
//        @weakify(subscriber)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            @strongify(subscriber)
//            [subscriber sendNext:@"async Hello"];
//        });
//        
//        NSObject *sub = subscriber;
//        [sub.rac_willDeallocSignal subscribeCompleted:^{
//            NSLog(@"订阅者释放");
//        }];
//        
//        return nil;
//    }];
    
//    @weakify(signal)
//    [signal.rac_willDeallocSignal subscribeCompleted:^{
//        @strongify(signal)
//        NSLog(@"%@ 信号释放", signal);
//    }];
    
//    RACMulticastConnection *connection = [signal publish];
//    [connection autoconnect];
//    [connection.signal subscribeNext:^(NSString *x) {
//        NSLog(@"1: %@", x);
//    }];
//    
//    [connection.signal subscribeNext:^(NSString *x) {
//        NSLog(@"2: %@", x);
//    }];
    
//    [[connection autoconnect] subscribeNext:^(NSString *x) {
//        NSLog(@"3: %@", x);
//    }];
    
//    [connection connect];
    
    RACSubject *sub1 = [RACSubject subject];
//    RACSignal *sub2 = [sub1 map:^id(id value) {
//        return value;
//    }];
    [sub1 subscribeNext:^(id x) {
        NSLog(@"111");
    } completed:^{
        NSLog(@"222");
    }];
//    [sub2 subscribeNext:^(id x) {
//        NSLog(@"333");
//    } completed:^{
//        NSLog(@"444");
//    }];
//
//    [sub1 sendNext:@"hello"];
//    [sub1 sendCompleted];
    [sub1 sendCompleted];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sub1 sendCompleted];
    });
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:button];
//    [button setTitle:@"点击我" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"Next");
//    } completed:^{
//        NSLog(@"Finished");
//    }];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [button removeFromSuperview];
//    });
    
    
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear");
//}

@end
