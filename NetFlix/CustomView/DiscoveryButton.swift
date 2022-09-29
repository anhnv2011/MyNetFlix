//
//  DiscoveryButton.swift
//  NetFlix
//
//  Created by MAC on 9/13/22.
//

import UIKit

struct DiscoveryButtonModel {
    let text:String
    let image: UIImage?
    let backgroundColor: UIColor?
}
class DiscoveryButton:UIButton {
    private let titleButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.semibold(ofSize: 20)
        return label
    }()
     let imageButton:UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.tintColor = .black
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleButton)
        addSubview(imageButton)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: DiscoveryButtonModel){
        titleButton.text = model.text
        backgroundColor = model.backgroundColor
        imageButton.image = model.image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageButton.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor,width: 40, height: 40, topPadding: 8, bottomPadding: 8, leftPadding: 8)
             
        titleButton.anchor(left: imageButton.rightAnchor, right: rightAnchor, centerY: centerYAnchor, leftPadding: 7, rightPadding: 8)

      
        
    }
}
