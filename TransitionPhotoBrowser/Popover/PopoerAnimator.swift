//
//  PopoerAnimator.swift
//  MySwift
//
//  Created by 王希顺 on 16/7/14.
//  Copyright © 2016年 CCE. All rights reserved.
//

import UIKit

class PopoerAnimator: NSObject , UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning {
    
    var isPresent = false
    
    var presentFrame = CGRectZero

    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pop = PoprverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        pop.presentFrame = presentFrame
        
        return pop
    }
    
    /**
     告诉系统谁来moda视图
     - parameter presented:  被推出的控制器
     - parameter presenting: 推的控制器
     
     - returns: self
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        
        return self
    }
    
    
    /**
     告诉系统谁来取消视图
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false

        return self
    }
    
    /**
     动画时长
     
     - parameter transitionContext: 上下文
     
     - returns: 时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    
    /**
     告诉系统如何动画, 无论是展现还是消失都会调用这个方法
     
     :param: transitionContext 上下文, 里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            let  toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            toView.alpha = 0.1

            //将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            //设置锚点
//            toView.layer.anchorPoint = CGPointMake(0.5, 0)
            
            //执行动画
            
            UIView.animateWithDuration(0.5, animations: {
                toView.alpha = 1.0

                }, completion: { (_) in
                    // 动画执行完毕, 一定要告诉系统
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
            
        }else {
            
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            
            //将视图添加到容器上
            transitionContext.containerView()?.addSubview(fromView)
            //设置锚点
//            fromView.layer.anchorPoint = CGPointMake(0.5, 0)
            
            //执行动画

            UIView.animateWithDuration(0.5, animations: {

                fromView.alpha = 0

                }, completion: { (_) in
                    
                    transitionContext.completeTransition(true)
            })
            
        }
    }
}
