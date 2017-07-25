//
//  UserViewModel.h
//  LeoCommonObjc
//
//  Created by 李理 on 2017/7/20.
//  Copyright © 2017年 李理. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserViewModel : NSObject

@property (nonatomic, strong) NSAttributedString *nameText;

@property (nonatomic, strong) UserModel *model;

@end
