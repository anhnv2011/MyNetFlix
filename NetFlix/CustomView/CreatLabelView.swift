//
//  CreatLabelView.swift
//  NetFlix
//
//  Created by MAC on 9/25/22.
//

import Foundation
import UIKit

struct ActionLabelViewModel {
    let text: String
    let actionTitle: String
}

class CreatLabelView: UIView {
    var didTapCreatPlaylist: (()-> Void)?

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.labelColor(), for: .normal)
        button.backgroundColor = UIColor.buttonBackground()
        button.layer.cornerRadius = 12
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubview(button)
        addSubview(label)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    @objc func didTapButton() {
        //delegate?.actionLabelViewDidTapButton(self)
        didTapCreatPlaylist!()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        button.frame = CGRect(x: 100 , y: 100, width: 100, height: 100)

//        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
//        button.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
        label.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: 200, height: 32)
        button.anchor(top: label.bottomAnchor, centerX: centerXAnchor, width: 200, height: 32, topPadding: 22)

    }

    func configure(with model: ActionLabelViewModel) {
        label.text = model.text
        button.setTitle(model.actionTitle, for: .normal)
    }
}

