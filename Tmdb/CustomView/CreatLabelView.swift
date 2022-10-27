//
//  CreatLabelView.swift
//  Tmdb
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
    var didTapCreatLibrary: (()-> Void)?

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.labelColor()
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
        backgroundColor = UIColor.popupBackground()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    @objc func didTapButton() {
        //delegate?.actionLabelViewDidTapButton(self)
        didTapCreatLibrary!()
    }

    override func layoutSubviews() {

        label.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: 200, height: 32)
        button.anchor(top: label.bottomAnchor, centerX: centerXAnchor, width: 200, height: 44, topPadding: 24)

    }


    func configure(with model: ActionLabelViewModel) {
        label.text = model.text
        button.setTitle(model.actionTitle, for: .normal)
    }
}

