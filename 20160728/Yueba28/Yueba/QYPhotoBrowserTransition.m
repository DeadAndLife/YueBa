//
//  QYPhotoBrowserTransition.m
//  Yueba
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYPhotoBrowserTransition.h"
#import <SWRevealViewController.h>
#import "ChartVC.h"
#import "QYPhotoBrowser.h"

@implementation QYPhotoBrowserTransition

//在执行转场的时候,要被调用,产生动画
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //显示的动画
    if (_isShow) {
        SWRevealViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UINavigationController *rightVC = (UINavigationController *)fromVC.rightViewController;
        ChartVC *chartVC = (ChartVC *)rightVC.topViewController;
        
        //目标控制器
        QYPhotoBrowser *photo = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        //显示的View
        UIView *container = transitionContext.containerView;
        
        //动画ImageView
        UIImageView *animationImageView = [[UIImageView alloc] initWithImage:chartVC.seletedImageView.image];
        animationImageView.contentMode = UIViewContentModeScaleAspectFill;
        //frame是相对父视图而言
        animationImageView.frame = [container convertRect:chartVC.seletedImageView.frame fromView:chartVC.seletedImageView.superview];
        animationImageView.backgroundColor = [UIColor blackColor];
        
        //当取消的时候,动画还原
        photo.originFrame = animationImageView.frame;
        
        [container addSubview:photo.view];
        photo.view.alpha = 0;
        [container addSubview:animationImageView];
        
        //执行动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //有小变大到目标控制器
            animationImageView.frame = photo.view.frame;
        } completion:^(BOOL finished) {
            //结束后,去掉动画View
            photo.view.alpha = 1.f;
            [animationImageView removeFromSuperview];
            
//            bool result = [transitionContext transitionWasCancelled];
            
            //转场结束
            [transitionContext completeTransition:YES];
        }];
        
        
    }else{//消失的动画
        //起始控制器
        QYPhotoBrowser *browser = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        //转场View
        UIView *container = [transitionContext containerView];
        
        //构造转场动画View
        UIImageView *animationView = [[UIImageView alloc] initWithImage:browser.imageView.image];
        animationView.contentMode = UIViewContentModeScaleAspectFill;
        animationView.frame = [container convertRect:browser.imageView.frame fromView:browser.imageView.superview];
        
        [container addSubview:toVC.view];
        [container addSubview:animationView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            animationView.frame = browser.originFrame;
        } completion:^(BOOL finished) {
            [animationView removeFromSuperview];
            
            //转场结束
            [transitionContext completeTransition:YES];
        }];
        
        
    }
}

//动画时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}


@end
