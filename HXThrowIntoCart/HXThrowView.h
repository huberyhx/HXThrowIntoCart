//
//  HXThrowView.h
//  HXThrowIntoCart
//
//  Created by XIU-Developer on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 这里可以修改为继承UIbutton或者UIView
 为了方便显示图片 我这里继承了UIImageView
 */
@interface HXThrowView : UIImageView
- (void)goWithPoint:(CGPoint)point;
/**
 时间系数,值越大动画时间越长
 */
@property (nonatomic, assign) CGFloat  timeRatio;

@end
