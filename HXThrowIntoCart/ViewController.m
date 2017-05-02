//
//  ViewController.m
//  HXThrowIntoCart
//
//  Created by XIU-Developer on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "HXThrowView.h"

@interface ViewController ()
@property (nonatomic, weak) UIImageView *cartImageView;
@property (nonatomic, weak) HXThrowView *throwView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cartImageView];//添加购物车图片
    [self throwView];//商品
    /**
     商品和购物车的位置可以在下面懒加载中更改
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /**
     View用方法:
     1:创建View
     2:调用对象方法告诉View购物车的位置 开始抛物
     */
    self.throwView.timeRatio = 1;//时间系数
    [self.throwView goWithPoint:self.cartImageView.center];
}

#pragma 懒加载
- (HXThrowView *)throwView{
    if (!_throwView) {
        HXThrowView *throwView = [[HXThrowView alloc]initWithImage:[UIImage imageNamed:@"goods"]];
        throwView.center = CGPointMake(30, 30);
        [self.view addSubview:throwView];
        _throwView = throwView;
    }
    return _throwView;
}

- (UIImageView *)cartImageView{
    if (!_cartImageView) {
        UIImageView *imageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shopping_cart"]];
        [self.view addSubview:imageView];
        imageView.center = CGPointMake(244, 144);
        _cartImageView = imageView;
    }
    return _cartImageView;
}
@end
