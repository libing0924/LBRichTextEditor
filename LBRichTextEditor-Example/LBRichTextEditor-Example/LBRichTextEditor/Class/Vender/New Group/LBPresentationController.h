//
//  LBAlertController.h
//  LBAlertController
//
//  Created by smufs on 2016/4/6.
//  Copyright © 2016年 李冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTransitionAnimatorDelegate.h"
#import "LBTransitionAnimator.h"

NS_ASSUME_NONNULL_BEGIN
@interface LBPresentationController : UIPresentationController
/// 代理
@property (nonatomic, assign, nonnull)id <LBPresentationControllerDelegate>  hg_delegate;
/// 蒙版背景
@property (nonatomic, strong, nonnull) UIView  *coverView;
/// 激活拖拽消失手势,默认NO---只支持animateStyle= Left Top Bottom
@property (nonatomic, assign) BOOL activeDrag;
/**
 *  初始化方法
 *
 *  @param presentedViewController  被转场的控制器
 *  @param presentingViewController 负责转场的控制器
 *  @param animateStyle             转场动画类型
 *  @param presentFrame             被转场控制器的视图frame
 *  @param backgroundColor          蒙版背景颜色
 *  @param duration                 动画时间
 *  @param response                 蒙版是否响应点击时间
 *
 *  @return HGPresentationController
 */
- (instancetype )initWithPresentedViewController:(nonnull UIViewController *)presentedViewController
                        presentingViewController:(nonnull UIViewController *)presentingViewController
                                 backgroundColor:(nonnull UIColor *)backgroundColor
                                    animateStyle:(LBTransitionAnimatorStyle)animateStyle
                                    presentFrame:(CGRect)presentFrame
                                        duration:(NSTimeInterval )duration
                                        response:(BOOL)response;


@end
NS_ASSUME_NONNULL_END

