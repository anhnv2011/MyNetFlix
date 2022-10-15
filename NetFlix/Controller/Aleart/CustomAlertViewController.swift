//
//  CustomAlertViewController.swift
//  NetFlix
//
//  Created by MAC on 10/14/22.
//

import UIKit
enum AlertViewStyle{
    case light
    case dark
    
    var backgroundColor: UIColor{
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.black.withAlphaComponent(0.8)
        }
    }
    // Color for title and message
    var textColor: UIColor{
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
}
class CustomAlertViewController: UIViewController {

    private var alertTitle: String! // Title
    private var message: String! // Message
    private var axis: NSLayoutConstraint.Axis = .horizontal
    private var actions = [ActionAlert]()
    private var alertStyle = AlertViewStyle.light
    private lazy var backdropView: UIView = {
        let view = createASimpleView(with: UIColor.black.withAlphaComponent(0.0))
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = createSimpleUILabelWith(textColor: alertStyle.textColor, font: UIFont.boldSystemFont(ofSize: 17.0))
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = createSimpleUILabelWith(textColor: alertStyle.textColor, font: UIFont.systemFont(ofSize: 15.0))
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = createSimpleStackViewWith(axis: .vertical, spacing: 5.0)
        // For title we want to take the intrinsic content size
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var actionsStackView: UIStackView = {
        let stackView = createSimpleStackViewWith(axis: self.axis, spacing: 10.0)
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = createASimpleView(with: alertStyle.backgroundColor)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        animateAlert()
    }
    /// Initialize  the alert view
    /// - Parameters:
    ///   - title: Title of  the pop up
    ///   - message: Message
    ///   - actions: Actions to be done
    ///   - axis: Orientation of buttons, whether to be arranged vertically or horizontally
    ///   - style: alertStyle default is normal
    init(withTitle title: String?, message: String?, actions: [ActionAlert], axis: NSLayoutConstraint.Axis, style: AlertViewStyle = .light) {
        super.init(nibName: nil, bundle: nil)
        self.actions = actions
        self.alertTitle = title
        self.message = message
        self.axis = axis
        self.alertStyle = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func animateAlert() {
        backdropView.alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.backdropView.alpha = 1.0
            self.backdropView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.containerView.transform = .identity
        })
    }
    
    private func setUpUI() {
        view.addSubview(backdropView)
        view.addSubview(containerView)
        containerView.addSubview(titleStackView)
        containerView.addSubview(actionsStackView)
        var containerWidthMultiplier: CGFloat = 0.8
        if UIDevice.current.userInterfaceIdiom == .pad {
            containerWidthMultiplier = 0.4
        }
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: containerWidthMultiplier),
                        
            titleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24.0),
            titleStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24.0),
            titleStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24.0),
            
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backdropView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            actionsStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 8.0),
            actionsStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24.0),
            actionsStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24.0),
            actionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24.0)
        ])

        for action in actions {
            let actionButton = ActionAlertButton(action: action)
            actionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            actionsStackView.addArrangedSubview(actionButton)
        }
        setUpTitleLabels()
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(messageLabel)
    }
    
    private func setUpTitleLabels() {
        titleLabel.text = alertTitle
        messageLabel.text = message
        
        // If title or message is empty just hide that...
        titleLabel.isHidden = alertTitle != nil ? false : true
        messageLabel.isHidden = message != nil ? false : true
    }

    // MARK: Convenience functions
    private func createSimpleStackViewWith(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 1) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func createSimpleUILabelWith(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor
        label.textAlignment = .center
        label.font = font
        return label
    }
    
    private func createASimpleView(with backgroundColor: UIColor = UIColor.white, cornerRadius: CGFloat = 0.0) -> UIView {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = backgroundColor
        newView.layer.cornerRadius = cornerRadius
        return newView
    }
    

}
