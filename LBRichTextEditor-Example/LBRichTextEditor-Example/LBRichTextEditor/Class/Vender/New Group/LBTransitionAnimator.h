//
//  LBAlertController.h
//  LBAlertController
//
//  Created by smufs on 2016/4/6.
//  Copyright © 2016年 李冰. All rights reserved.
//

#import "LBTransitionAnimatorDelegate.h"

#ifndef HGWeakSelf
    #define HGWeakSelf __weak __typeof(self)weakSelf = self;
#endif

#ifndef dispatch_main_async_safe
    #define dispatch_main_async_safe(block)\
        if ([NSThread isMainThread]) {\
            block();\
        } else {\
            dispatch_async(dispatch_get_main_queue(), block);\
        }
#endif


typedef NS_ENUM(NSInteger,LBTransitionAnimatorStyle)
{
    
    LBTransitionAnimatorCustomStyle= 0,         //自定义样式
///////////////参照UIWinow///////////////
    LBTransitionAnimatorFromLeftStyle,          //从左边弹出样式
    LBTransitionAnimatorFromRightStyle,         //从右边弹出样式
    LBTransitionAnimatorFromTopStyle,           //从顶部弹出样式
    LBTransitionAnimatorFromBottomStyle,        //从底部弹出样式
    
///////////////参照PresentView///////////
    LBTransitionAnimatorHiddenStyle,            //显示隐藏样式
    LBTransitionAnimatorVerticalScaleStyle,     //垂直压缩样式
    LBTransitionAnimatorHorizontalScaleStyle,   //水平压缩样式
    LBTransitionAnimatorCenterStyle,            //中点消失样式
    LBTransitionAnimatorFocusTopCenterStyle,    //顶部中点消失样式
    LBTransitionAnimatorFocusTopLeftStyle,      //顶部左上角消失样式
    LBTransitionAnimatorFocusTopRightStyle,     //顶部右上角消失样式
};

/// 默认动画时间
FOUNDATION_EXTERN   NSTimeInterval  const   defaultDuratin;


NS_ASSUME_NONNULL_BEGIN
@interface LBTransitionAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
/**
 *  构造方法
 *
 *  @param animateStyle    动画类型
 *  @param relateView      参照的view
 *  @param presentFrame    弹出视图的frame
 *  @param backgroundColor 背景色
 *  @param delegate        代理
 *  @param animated        是否动画
 */
- (instancetype)initWithAnimateStyle:(LBTransitionAnimatorStyle)animateStyle
                          relateView:(nullable UIView *)relateView
                        presentFrame:(CGRect)presentFrame
                     backgroundColor:(nullable UIColor *)backgroundColor
                            delegate:(nullable id <LBTransitionAnimatorDelegate>)delegate
                            animated:(BOOL)animated NS_DESIGNATED_INITIALIZER;



- (LBPresentationController * _Nonnull )getPresentationController;
@end
NS_ASSUME_NONNULL_END




