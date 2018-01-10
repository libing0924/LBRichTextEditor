//
//  LBAlertController.h
//  LBAlertController
//
//  Created by smufs on 2016/4/6.
//  Copyright © 2016年 李冰. All rights reserved.
//

#import "UIViewController+LBAnimator.h"
#import "LBTransitionAnimator.h"
#import <objc/runtime.h>


static NSString * const LBTransitionAnimatorKey=@"LBTransitionAnimatorKey";

@implementation UIViewController (LBAnimator)

/**
 *  viewController的模态弹出转场动画类目
 *
 *  @param viewControllerToPresent 要弹出的视图控制器
 *  @param style                   转场动画样式
 *  @param delegate                转场动画代理
 *  @param presentFrame            弹出的视图控制器大小
 *  @param backgroundColor         背景颜色
 *  @param flag                    标记(是否动画弹出)
 *
 *  @return 转场动画对象
 */
-(LBTransitionAnimator *)lb_presentViewController:(UIViewController *)viewControllerToPresent
                                     animateStyle:(LBTransitionAnimatorStyle)style
                                         delegate:(id<LBTransitionAnimatorDelegate>)delegate
                                     presentFrame:(CGRect)presentFrame
                                  backgroundColor:(UIColor *)backgroundColor
                                         animated:(BOOL)flag
{
    LBTransitionAnimator *animator=[[LBTransitionAnimator alloc]initWithAnimateStyle:style
                                                                          relateView:self.view
                                                                        presentFrame:presentFrame
                                                                     backgroundColor:backgroundColor
                                                                            delegate:delegate
                                                                            animated:flag];
    
    objc_setAssociatedObject(self, &LBTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &LBTransitionAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 设置模态弹出视图控制器的转场动画代理和模态弹出样式
    viewControllerToPresent.modalPresentationStyle=UIModalPresentationCustom;
    viewControllerToPresent.transitioningDelegate=animator;
    
    void (^presentBlock)(void) = ^ (void) {
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    };
    dispatch_main_async_safe(presentBlock);
    
    return  animator;
}

- (void)lb_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    LBTransitionAnimator *animator=(LBTransitionAnimator *)self.transitioningDelegate;
    if (!flag) [animator transitionDuration:0];
    void (^dismissBlock)(void) = ^ (void) {
        [self dismissViewControllerAnimated:flag completion:completion];
    };
    dispatch_main_async_safe(dismissBlock);
    objc_setAssociatedObject([self currentPresentingViewController], &LBTransitionAnimatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LBPresentationController *)lb_getPresentationController
{
    LBTransitionAnimator *animator=(LBTransitionAnimator *)self.transitioningDelegate;
    NSAssert1([[animator class] isSubclassOfClass:[LBTransitionAnimator class]], @"负责转场的对象`%@`不是HGTransitionAnimator或它的子类,获取失败!",animator);
    return [animator getPresentationController];
}
- (UIViewController *)currentPresentingViewController
{
    if ([self.presentingViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav=(UINavigationController *)self.presentingViewController;
        return  [nav.viewControllers lastObject];;
    }
    return  self.presentingViewController;
}
@end



