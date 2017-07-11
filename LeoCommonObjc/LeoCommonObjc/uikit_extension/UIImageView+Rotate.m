//
//  UIImageView+Rotate.m
//  snail_shared
//
//  Created by 李理 on 2016/10/25.
//
//

#import "UIImageView+Rotate.h"

@implementation UIImageView (Rotate)

- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(NSInteger)repeatCount
{
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    //fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    fullRotation.toValue = [NSNumber numberWithFloat:-(2*M_PI)]; // added this minus sign as i want to rotate it to anticlockwise
    fullRotation.duration = duration;
    fullRotation.speed = 2.0f;              // Changed rotation speed
    if (repeatCount == 0)
        fullRotation.repeatCount = MAXFLOAT;
    else
        fullRotation.repeatCount = repeatCount;
    
    [self.layer addAnimation:fullRotation forKey:@"360"];
}

//Not using this methods :)

- (void)stopAllAnimations
{
    
    [self.layer removeAllAnimations];
};

- (void)pauseAnimations
{
    
    [self pauseLayer:self.layer];
}

- (void)resumeAnimations
{
    
    [self resumeLayer:self.layer];
}

- (void)pauseLayer:(CALayer *)layer
{
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer
{
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
