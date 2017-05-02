//
//  HXThrowView.m
//  HXThrowIntoCart
//
//  Created by XIU-Developer on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HXThrowView.h"

#define BaseTime 1.0
#define BaseSpace 300.0

@interface HXThrowView()<CAAnimationDelegate>
@property (nonatomic, strong) CABasicAnimation *rorationAnim;
@property (nonatomic, strong) CAKeyframeAnimation *positionAnim;
@end

@implementation HXThrowView

- (void)goWithPoint:(CGPoint)point{
    //创建抛物线
    UIBezierPath *path = [UIBezierPath bezierPath];
    //抛物线起点
    [path moveToPoint:self.center];
    CGFloat controlX = point.x;
    CGFloat controlY = self.center.y;
    //抛物线的控制点
    CGPoint controlPoint = CGPointMake(controlX, controlY);
    [path addQuadCurveToPoint:point controlPoint:controlPoint];
    
    //物品和购物车的直线距离
    CGFloat space = sqrt((point.x - self.center.x) * (point.x - self.center.x) + (point.y - self.center.y) * (point.y - self.center.y));
    //根据直线距离更改动画时间
    CGFloat duration = self.timeRatio? space/BaseSpace * BaseTime * self.timeRatio : space/BaseSpace * BaseTime;
    
    //抛物动画
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation animation];
    positionAnim.keyPath = @"position";
    positionAnim.path = path.CGPath;
    positionAnim.duration = duration;
    positionAnim.repeatCount = 1;
    
    //组动画
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    groupAnim.delegate = self;
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.duration = duration;
    groupAnim.animations = @[positionAnim,self.rorationAnim];
    [self.layer addAnimation:groupAnim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画执行结束移除view
    [self removeFromSuperview];
}

- (CABasicAnimation *)rorationAnim{
    if (!_rorationAnim) {
        //旋转动画
        _rorationAnim = [CABasicAnimation animation];
        _rorationAnim.keyPath = @"transform.rotation";
        _rorationAnim.fromValue = @0;
        _rorationAnim.toValue = @(M_PI * 2);
        _rorationAnim.repeatCount = MAXFLOAT;
        _rorationAnim.duration = 0.28;
    }
    return _rorationAnim;
}

@end
