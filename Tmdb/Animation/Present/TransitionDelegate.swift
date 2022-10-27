//
//  TransitionDelegate.swift
//  NetFlix
//
//  Created by MAC on 10/13/22.
//

import Foundation
import UIKit
class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleTransform(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleTransform(presenting: false)
    }
    
}
