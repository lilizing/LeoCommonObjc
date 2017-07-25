//
//  UserViewModel.m
//  LeoCommonObjc
//
//  Created by 李理 on 2017/7/20.
//  Copyright © 2017年 李理. All rights reserved.
//

#import "UserViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIButton+RACCommandSupport+Ext.h"
#import "UIView+Ext.h"

@implementation UserViewModel

-(instancetype)initWithModel:(UserModel *)model {
    if (self = [super init]) {
        self.model = model;
        
//        [RACObserver(self.model, name) ]
    }
    return self;
}

@end
