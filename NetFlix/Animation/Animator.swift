//
//  Animator.swift
//  NetFlix
//
//  Created by MAC on 10/3/22.
//

import Foundation
import UIKit
extension UIViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = Animator(presenting: true)
        return animator
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = Animator(presenting: false)
        return animator

    }
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//           return FadeAnimationController(presenting: true)
//       }
//
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//           return FadeAnimationController(presenting: false)
//       }
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool
    init(presenting: Bool) {
           self.presenting = presenting
           print(presenting)
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            toView.alpha = 0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            [weak self] in
                if self!.presenting {
                    toView.transform = CGAffineTransform.identity
                    toView.alpha = 1
                } else {
                    fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
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

//class FadeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
//
//    private let presenting: Bool
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 2
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromView = transitionContext.view(forKey: .from) else { return }
//        guard let toView = transitionContext.view(forKey: .to) else { return }
//
//        let container = transitionContext.containerView
//        if presenting {
//            container.addSubview(toView)
//            toView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//        } else {
////            container.insertSubview(toView, belowSubview: fromView)
//        }
//
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            if self.presenting {
//                toView.transform = CGAffineTransform.identity
//            } else {
//                fromView.transform = CGAffineTransform.identity
//            }
//        }) { _ in
//            let success = !transitionContext.transitionWasCancelled
//            if !success {
//                toView.removeFromSuperview()
//            }
//            transitionContext.completeTransition(success)
//        }
//    }
//
//    init(presenting: Bool) {
//        self.presenting = presenting
//        print(presenting)
//    }
//}
//final class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return FadeAnimationController(presenting: true)
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return FadeAnimationController(presenting: false)
//    }
//}
