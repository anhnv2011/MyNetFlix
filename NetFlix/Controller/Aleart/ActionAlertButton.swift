//
//  ActionAlertButton.swift
//  NetFlix
//
//  Created by MAC on 10/14/22.
//

import Foundation
import UIKit
class ActionAlertButton: UIButton {
    private var actionHandler: (() -> Void)!

    init(action: ActionAlert) {
        super.init(frame: .zero)
        self.actionHandler = action.actionHandler
        self.setUpButtonWith(action: action)
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpButtonWith(action: ActionAlert) {
        self.titleLabel?.font = UIFont.semibold(ofSize: 18)
        self.setTitle(action.title, for: .normal)
        self.layer.cornerRadius = 5
        addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        self.setUpUI(style: action.style)
    }

    private func setUpUI(style: ActionAlertStyle) {
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.titleColor, for: .normal)
        self.setTitleColor(style.highlightedTitleColor, for: .highlighted)
    }

    @objc func didTapButton() {
        self.actionHandler?()
    }

    
}
