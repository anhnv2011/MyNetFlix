//
//  Animator.swift
//  NetFlix
//
//  Created by MAC on 10/3/22.
//

import Foundation
import UIKit
class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimator(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimator(presenting: false)
    }
    
}

//extension UIViewController: UIViewControllerTransitioningDelegate {
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = Animator(presenting: true)
//        return animator
//    }
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = Animator(presenting: false)
//        return animator
//
//    }
//    //    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    //           return FadeAnimationController(presenting: true)
//    //       }
//    //
//    //    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    //           return FadeAnimationController(presenting: false)
//    //       }
//}

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool
    init(presenting: Bool) {
        self.presenting = presenting
        print(presenting)
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let container = transitionContext.containerView
        if presenting {
            toView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

            container.addSubview(toView)
            
            toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            toView.alpha = 0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            [weak self] in
            if self!.presenting {
                toView.transform = CGAffineTransform.identity
                toView.layoutIfNeeded()
                toView.alpha = 1
            } else {
                fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                fromView.alpha = 0
                
            }
        } completion: { (_) in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        
        
        
    }
}

