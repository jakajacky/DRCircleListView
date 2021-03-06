//
//  DRCircleListView.m
//  CircleListViewDemo
//
//  Created by 张小强 on 2018/5/15.
//  Copyright © 2018年 张小强. All rights reserved.
//

#import "DRCircleListView.h"

@interface DRCircleListView ()
@property (nonatomic, strong) CAShapeLayer *contentlayer;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DRCircleListView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.yellowColor;
//        self.contentlayer = [[CAShapeLayer alloc] init];
//        UIBezierPath *b = [UIBezierPath bezierPathWithOvalInRect:self.frame];
//        self.contentlayer.path = b.CGPath;
//        self.contentlayer.frame = self.frame;
//        self.contentlayer.fillColor = UIColor.cyanColor.CGColor;
//        [self.layer addSublayer:self.contentlayer];
        
        self.contentView = [[UIView alloc] initWithFrame:frame];
        self.contentView.layer.cornerRadius = self.contentView.frame.size.width/2.0;
        self.contentView.backgroundColor = UIColor.cyanColor;
        [self addSubview:self.contentView];
        
        [self one];
    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint location = [touch locationInView:self];
    CGFloat previousRadian = [self radianToCenterPoint:self.center withPoint:previousLocation];
    CGFloat curRadian = [self radianToCenterPoint:self.center withPoint:location];
    CGFloat changedRadian = curRadian - previousRadian;
    
    NSLog(@"%f",changedRadian);
    self.changedRadian = changedRadian;// 记录
    [self rotateByRadian:changedRadian];
}

/**
 *  以ColorPanel的anchorPoint为坐标原点建立坐标系，计算坐标点|point|与坐标原点的连线距离x轴正方向的夹角
 *  @param centerPoint 坐标原点坐标
 *  @param point       某坐标点
 *
 *  @return 坐标点|point|与坐标原点的连线距离x轴正方向的夹角
 */
- (CGFloat)radianToCenterPoint:(CGPoint)centerPoint withPoint:(CGPoint)point {
    CGVector vector = CGVectorMake(point.x - centerPoint.x, point.y - centerPoint.y);
    return atan2f(vector.dy, vector.dx);
}

/**
 *  将图层旋转radian弧度
 *  @param radian 旋转的弧度
 */
- (void)rotateByRadian:(CGFloat)radian {
    
    CGAffineTransform transform = self.contentView.layer.affineTransform;
    transform = CGAffineTransformRotate(transform, radian);
    self.contentView.layer.affineTransform = transform;
}

- (void)one {
    CGFloat N = 28*3, R = self.frame.size.width/2.0-30;
    CGFloat angle = 360.0/N * M_PI/180.0;
    
    for (int i = 0; i < N; i++) {
        CGFloat c_L = [UIApplication sharedApplication].windows.firstObject.bounds.size.width-45-2*2; // 弦长
        CGFloat c_R = R; // 半径
        CGFloat c_angle = 2*asinf(c_L/(c_R*2));// 圆心角
        CGFloat c_angle_real = c_angle/(M_PI/180);
        CGFloat c_total_angle = (180-(180-c_angle_real)/2.0);
        CGFloat start = i*angle - c_total_angle*M_PI/180 - angle;
        CGFloat end = start + angle;
        
        // 可以利用贝塞尔path获取圆弧终点的位置CGPoint
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:R startAngle:start endAngle:end clockwise:YES];
        // 等分点
        CGPoint position = path.currentPoint;
        // 在相应等分点上绘制元素
//        UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:position radius:45/2.0 startAngle:0 endAngle:2*M_PI clockwise:YES];
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        layer.fillColor = UIColor.blueColor.CGColor;
//        layer.path = p.CGPath;
//        [self.contentlayer addSublayer: layer];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        img.center = position;
        img.image = self.images[i%self.images.count];
        img.backgroundColor = UIColor.redColor;
        img.layer.cornerRadius = 45/2.0;
        img.layer.masksToBounds = YES;
        img.tag = i+1000;
        img.userInteractionEnabled = YES;
        [self.contentView addSubview:img];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [img addGestureRecognizer:tap];
        
        // 等分弧线段
        CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
        circleLayer.lineWidth = 4;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = (i%2 == 0) ? UIColor.redColor.CGColor : UIColor.greenColor.CGColor;
        circleLayer.path = path.CGPath;
        [self.contentView.layer addSublayer:circleLayer];
    }
}

- (void)tap:(UIGestureRecognizer *)ges {
    UIImageView *img = ges.view;
    NSLog(@"点击list%ld",img.tag);
}

// 根据cell决定圆盘大小
- (void)three {
    CGFloat W = 45.0,N = 28.0;
    CGFloat angle = M_PI*2.0 / N;
    CGFloat R = W;  //默认让半径等于W
    
    // 计算 x 是否 <= w/2
    CGFloat x = R * sin(angle/2);
    while (x<(W/2.0+10)) {
        R += 1;
        x = R * sin(angle/2); //重叠的最小间距
    }
    for (int i = 0; i < N; i++) {
        CGFloat start = i*angle;
        CGFloat end = start + angle;
        
        // 可以利用贝塞尔path获取圆弧终点的位置CGPoint
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:R startAngle:start endAngle:end clockwise:YES];
        // 等分点
        CGPoint position = path.currentPoint;
        // 在相应等分点上绘制元素
        UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:position radius:W/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.fillColor = UIColor.blueColor.CGColor;
        layer.path = p.CGPath;
        [self.layer addSublayer:layer];
        
        // 等分弧线段
        CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
        circleLayer.lineWidth = 4;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = (i%2 == 0) ? UIColor.redColor.CGColor : UIColor.greenColor.CGColor;
        circleLayer.path = path.CGPath;
        [self.layer addSublayer:circleLayer];
    }
}

@end
