效果图:
![抛物.gif](http://upload-images.jianshu.io/upload_images/2954364-a72f17897117ae86.gif?imageMogr2/auto-orient/strip)
类用法:
1:HXThrowView拖入项目中
2:创建View
3:调用该方法 告诉view抛向哪里
```
[self.throwView goWithPoint:CGPointMake(80, 180)];
```
为了方便显示图片,类继承自ImageView
用的时候可以修改为继承Button或者其他

类实现:
动画非常简单
使用了核心动画中的
CABasicAnimation
CAKeyframeAnimation
然后用组动画CAAnimationGroup包装一下

CABasicAnimation:
用BasicAnimation来做旋转
由于旋转的时候不需要设置其属性
所以直接写成了懒加载:
```
- (CABasicAnimation *)rorationAnim{
    if (!_rorationAnim) {
        //旋转动画
        _rorationAnim = [CABasicAnimation animation];
        /*
         一些常用的animationWithKeyPath值的总结
         transform.scale    比例转化
         transform.scale.x    宽的比例
         transform.scale.y    高的比例
         transform.rotation.x    围绕x轴旋转
         transform.rotation.y    围绕y轴旋转
         transform.rotation.z    围绕z轴旋转
         cornerRadius    圆角的设置
         backgroundColor    背景颜色的变化
         bounds    大小，中心不变
         position    位置(中心点的改变)
         contents    内容(更换图片)
         opacity    透明度
         contentsRect.size.width    横向拉伸缩放
         */
        _rorationAnim.keyPath = @"transform.rotation";
        //起始位置
        _rorationAnim.fromValue = @0;
        //末位置
        _rorationAnim.toValue = @(M_PI * 2);
        //循环次数
        _rorationAnim.repeatCount = MAXFLOAT;
        //动画时间
        _rorationAnim.duration = 0.28;
    }
    return _rorationAnim;
}

```

路径生成:
根据拿到的要抛向的点
和自己的center来生成抛物路径
用两点所在直线的交叉点来做贝塞尔曲线的控制点
根据路径长短来更改动画时间
![交叉点.jpeg](http://upload-images.jianshu.io/upload_images/2954364-f2a01c658be7a4d4.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
代码如下:
```
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
```

CAKeyframeAnimation:
```
    //抛物动画
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation animation];
    //动画类型
    positionAnim.keyPath = @"position";
    //设置👆生成的抛物路径
    positionAnim.path = path.CGPath;
    //设置👆计算出的抛物时间
    positionAnim.duration = duration;
    //动画重复次数
    positionAnim.repeatCount = 1;
```

CAAnimationGroup:
组动画把抛物动画和旋转动画包装起来
```
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    //设置动画节奏
    /*
         控制动画运行的节奏
         kCAMediaTimingFunctionLinear (线性）：匀速，给你一个相对静态的感觉
         kCAMediaTimingFunctionEaseIn (渐进）：动画缓慢进入，然后加速离开
         kCAMediaTimingFunctionEaseOut （渐出）：动画全速进入，然后减速的到达目的地
         kCAMediaTimingFunctionEaseInEaseOut (渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。
    */
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //设置动画代理 当动画结束的时候移除自己
    groupAnim.delegate = self;
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    //👆计算出的动画时间
    groupAnim.duration = duration;
    groupAnim.animations = @[positionAnim,self.rorationAnim];
    [self.layer addAnimation:groupAnim forKey:nil];
```

完成!

谢谢阅读
有不合适的地方请指教
喜欢请点个赞
抱拳了!
