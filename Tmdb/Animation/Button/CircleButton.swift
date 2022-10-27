//
//  File.swift
//  NetFlix
//
//  Created by MAC on 10/13/22.
//

import Foundation
import UIKit
class CircleButton {
    static func customAnimation (sender: UIButton, leftConstrain: NSLayoutConstraint,rightConstrain: NSLayoutConstraint, height: CGFloat,vc: UIViewController, completion : @escaping (() -> Void) ){
        sender.setTitle("", for: .normal)
        sender.clipsToBounds = true
        UIView.animate(withDuration: 0.75) {
            leftConstrain.constant = height
            rightConstrain.constant = height
            sender.layer.cornerRadius = sender.frame.height / 2
            vc.view.layoutIfNeeded()
            sender.backgroundColor = .black

        } completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut) {
                sender.transform = CGAffineTransform(scaleX: 20, y:400)
                
            } completion: { _ in
                completion()
                
            }


        }

    }
}
