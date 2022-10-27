//
//  CustomNavigationController.swift
//  NetFlix
//
//  Created by MAC on 10/13/22.
//

import UIKit
class NavigationDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return SimpleOver(popStyle: true)
        } else {
            return SimpleOver(popStyle: false)
        }
    }
    
}
