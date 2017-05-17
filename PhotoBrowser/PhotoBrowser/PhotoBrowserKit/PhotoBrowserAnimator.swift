//
//  PhotoBrowserAnimator.swift
//  PhotoBrowser
//
//  Created by weiguang on 2017/5/17.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath: IndexPath) -> CGRect;
    func endRect(indexPath: IndexPath) -> CGRect;
    func imageView(indexPath: IndexPath) -> UIImageView;
}

protocol AnimatorDismissedDelegate : NSObjectProtocol {
    func indexPathForDismissView() -> IndexPath
    func imageViewForDismissView() -> UIImageView
}


class PhotoBrowserAnimator: NSObject {

    var isPresented: Bool = false
    var indexPath: IndexPath?
    
    var presentedDelegate: AnimatorPresentedDelegate?
    var dismissDelegate: AnimatorDismissedDelegate?
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            animationForPresentedView(transitionContext: transitionContext)
        } else {
            animationForDismissedView(transitionContext: transitionContext)
        }
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        // 取出弹出的view
        let presentedView = transitionContext.view(forKey: .to)!
        // 将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        // 执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
    
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        // 取出消失的view
        let dismissedView = transitionContext.view(forKey: .from)!
        dismissedView.removeFromSuperview()
        
        // 取出执行动画的imageView
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismissView()
        
       
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
}





