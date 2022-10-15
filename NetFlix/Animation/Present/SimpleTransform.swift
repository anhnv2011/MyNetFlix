//
//  Animator.swift
//  NetFlix
//
//  Created by MAC on 10/3/22.
//

import Foundation
import UIKit

public class SimpleTransform: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool
    init(presenting: Bool) {
        self.presenting = presenting
        print(presenting)
    }
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let container = transitionContext.containerView
        if presenting {
            toView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)

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

