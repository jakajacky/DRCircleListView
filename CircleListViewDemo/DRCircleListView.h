//
//  DRCircleListView.h
//  CircleListViewDemo
//
//  Created by 张小强 on 2018/5/15.
//  Copyright © 2018年 张小强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRCircleListView : UIView
/**
 *  中心点的坐标值
 */
@property (nonatomic, assign) CGPoint centerPoint;


@property (nonatomic, assign) CGFloat changedRadian;

@property (nonatomic, strong) NSArray *images;

/**
 *  将图层旋转radian弧度
 *  @param radian 旋转的弧度
 */
- (void)rotateByRadian:(CGFloat)radian;
@end
