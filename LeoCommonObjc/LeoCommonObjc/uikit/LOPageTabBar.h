//
//  LOPageTabBar.h
//  LeoCommonObjc
//
//  Created by 李理 on 2017/8/2.
//  Copyright © 2017年 李理. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOPageTab : UIView

@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) NSAttributedString *selectedTitle;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@interface LOPageTabBar : UIView

@property (nonatomic, strong) NSArray<LOPageTab *> *tabs;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat lineMargin;
@property (nonatomic, assign) CGFloat lineOffset;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL bounces;

@end
