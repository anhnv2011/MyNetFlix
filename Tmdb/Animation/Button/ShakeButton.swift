//
//  ShakeButton.swift
//  Tmdb
//
//  Created by MAC on 10/13/22.
//

import UIKit
class ShakeButton {

    static func shake(sender: UIButton){
        let bounds = sender.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut) {
            sender.bounds = CGRect(
                x: bounds.origin.x - 60,
                y: bounds.origin.y,
                width: bounds.size.width + 60,
                height: bounds.size.height + 30)
        } completion: { (success) in
            if success {
                UIView.animate(withDuration: 0.5) {
                    sender.bounds  = bounds
                }
            }
        }
    }
}
