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

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *reduceSignal = [RACSignal combineLatest:@[self.nameField.rac_textSignal, self.passwordField.rac_textSignal] reduce:^id(NSString *name, NSString *password){
        return @(name.length > 3 && password.length > 5);
    }];
    
    [self.loginButton setEnabled:reduceSignal actionBlock:^(UIButton *sender) {
        NSLog(@"---");
    }];
}

@end
