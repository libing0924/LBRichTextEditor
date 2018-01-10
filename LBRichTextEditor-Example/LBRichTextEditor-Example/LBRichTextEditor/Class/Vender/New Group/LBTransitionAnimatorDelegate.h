//
//  LBAlertController.h
//  LBAlertController
//
//  Created by smufs on 2016/4/6.
//  Copyright © 2017年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - HGTransitionAnimatorDelegate,在`PresentingViewController`中使用
@class LBTransitionAnimator;
@protocol LBTransitionAnimatorDelegate <NSObject>
@optional

/**
 *  弹出控制器视图之后后调用该代理方法
 *  @param presented   被弹出的控制器
 */
- (void)transitionAnimator:(LBTransitionAnimator *)animator animationControllerForPresentedController:(UIViewController *)presented;

/**
 *  回收控制器视图之后调用该代理方法
 *  @param dismissed   被弹出的控制器
 */
- (void)transitionAnimator:(LBTransitionAnimator *)animator animationControllerForDismissedController:(UIViewController *)dismissed;

/**
 *  自定义动画需要用到,在该代理方法中实现动画效果
 *
 *  @param toView   即将显示的控制器视图
 *  @param duration 动画时间
 */
- (void)transitionAnimator:(LBTransitionAnimator *)animator animateTransitionToView:(UIView *)toView duration:(NSTimeInterval)duration;

/**
 *  自定义动画需要用到,在该代理方法中实现动画效果
 *
 *  @param fromView   即将消失的控制器视图
 *  @param duration 动画时间
 */
- (void)transitionAnimator:(LBTransitionAnimator *)animator animateTransitionFromView:(UIView *)fromView duration:(NSTimeInterval)duration;

/**
 *  设置动画时间
 *  注意:如果在构造函数里面设置了animated=NO, 避免实现该代理
 *  @return 动画时间
 */
- (NSTimeInterval)transitionDuration:(LBTransitionAnimator *)animator;

/**
 *  背景点击是否响应,默认YES
 */
- (BOOL)transitionAnimatorCanResponse:(LBTransitionAnimator *)animator;
@end

#pragma mark - HGPresentationControllerDelegate,在`PresentedViewController`中使用
@class LBPresentationController;
@protocol LBPresentationControllerDelegate <NSObject>

@optional
/**
 *  `蒙版`和`PresentedView`即将消失.
 *  在`PresentedViewController`设置是否需要消失动画,可以在该代理中做一些其他的操作.
 *  @param duration 即将消失花费的时间
 *
 *  @return 是否动画,默认YES。
 */
- (BOOL)presentedViewBeginDismiss:(NSTimeInterval)duration;

@end









