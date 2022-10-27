//
//  DetailFilmButton.swift
//  Tmdb
//
//  Created by MAC on 9/14/22.
//

import UIKit

class DetailFilmButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        setupButton()

    }
    func setupButton(){
        layer.cornerRadius = frame.size.height / 2
        backgroundColor = UIColor.buttonBackground()
    }
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                
                    self.transform = .init(scaleX: 0.4, y: 0.4)
                    self.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    
                    self.transform = .identity
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
  
}
