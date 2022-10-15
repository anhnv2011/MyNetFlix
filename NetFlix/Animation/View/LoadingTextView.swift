//
//  LoadingText.swift
//  NetFlix
//
//  Created by MAC on 10/12/22.
//

import UIKit
class LoadingTextView:UIView {
    
    
    let shimmerTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading".localized()
        label.font = UIFont.regular(ofSize: 88)
        //        label.textColor = UIColor(: 1, alpha: 0.9)
        label.textColor = .red
        //
        label.textAlignment = .center
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading".localized()
        label.font = UIFont.regular(ofSize: 88)
        label.textColor = UIColor(white: 1, alpha: 0.1)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI(){
        addSubview(textLabel)
        addSubview(shimmerTextLabel)
        backgroundColor = .black
        
        textLabel.anchor(left: leftAnchor, right: rightAnchor, centerY: centerYAnchor, leftPadding: 16, rightPadding: 16)
        shimmerTextLabel.anchor(left: leftAnchor, right: rightAnchor, centerY: centerYAnchor, leftPadding: 16, rightPadding: 16)
        layoutIfNeeded()
        shimmerAnimation()
        
    }
    private func shimmerAnimation(){
        let gradient = CAGradientLayer()
        gradient.frame = shimmerTextLabel.bounds
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor.clear.cgColor,
                           UIColor.black.cgColor,
                           UIColor.black.cgColor,
                           UIColor.clear.cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        
        let angle = -45 * CGFloat.pi / 180
        print(angle)
        gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        shimmerTextLabel.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -frame.width
        animation.toValue = frame.width
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards

        gradient.add(animation, forKey: "shimmerKey")
        layoutIfNeeded()
    }
}
