//
//  LBAlertController.h
//  LBAlertController
//
//  Created by smufs on 2016/4/6.
//  Copyright © 2016年 李冰. All rights reserved.
//
// 四个核心
// UIPresentationController 主要负责展示最后被弹出的VC
// UIViewControllerTransitioningDelegate 负责整合动画效果和展示的VC
// UIViewControllerAnimatedTransitioning 负责实际动画效果
// UIViewControllerContextTransitioning 关联过度相关的上下文


#import <UIKit/UIKit.h>

@interface UIView (HGExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@interface UIColor (HGExtension)
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;
@end
