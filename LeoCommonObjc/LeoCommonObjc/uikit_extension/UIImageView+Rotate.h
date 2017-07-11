//
//  UIImageView+Rotate.h
//  snail_shared
//
//  Created by 李理 on 2016/10/25.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (Rotate)

- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(NSInteger)repeatCount;
- (void)pauseAnimations;
- (void)resumeAnimations;
- (void)stopAllAnimations;

@end
