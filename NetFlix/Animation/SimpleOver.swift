//
//  SimpleOver.swift
//  NetFlix
//
//  Created by MAC on 10/11/22.
//

import Foundation
import UIKit

class CustomNavigationController: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return SimpleOver(popStyle: true)
        } else {
            return SimpleOver(popStyle: false)
        }
    }
    
}

class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {
    
    var popStyle: Bool = false
    init(popStyle: Bool) {
        self.popStyle = popStyle
        print(popStyle)
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if popStyle {
            
            animatePop(using: transitionContext)
            return
        }
        
        let fromView = transitionContext.viewController(forKey: .from)!
        let toView = transitionContext.viewController(forKey: .to)!
        
        let f = transitionContext.finalFrame(for: toView)
        
        let fOff = f.offsetBy(dx: f.width, dy: 200)
        toView.view.frame = fOff
        toView.view.alpha = 0
        transitionContext.containerView.insertSubview(toView.view, aboveSubview: fromView.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toView.view.frame = f
                toView.view.alpha = 1
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewController(forKey: .from)!
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.initialFrame(for: fromView)
        let fOffPop = f.offsetBy(dx: f.width, dy: 200)
        
        transitionContext.containerView.insertSubview(toView.view, belowSubview: fromView.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromView.view.frame = fOffPop
                fromView.view.alpha = 0
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
}
