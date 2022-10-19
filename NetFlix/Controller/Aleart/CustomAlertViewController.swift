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
    private var alertStyle = AlertViewStyle.dark
    private var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.layer.cornerRadius = 0.0
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = alertStyle.textColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
      
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = alertStyle.textColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var actionsStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = self.axis
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        // For title we want to take the intrinsic content size
        return stackView
       
    }()
    
    private lazy var containerView: UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = alertStyle.backgroundColor
        view.layer.cornerRadius = 0.0
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        animateAlert()
    }
    
    init(withTitle alertTitle: String?, message: String?, actions: [ActionAlert], axis: NSLayoutConstraint.Axis, style: AlertViewStyle = .dark) {
        super.init(nibName: nil, bundle: nil)
        self.actions = actions
        self.alertTitle = alertTitle
        self.message = message
        self.axis = axis
        self.alertStyle = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func animateAlert() {
        backgroundView.alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 1.0
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.containerView.transform = .identity
        })
    }
    
    private func setUpUI() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(titleStackView)
        containerView.addSubview(actionsStackView)
        let containerWidthMultiplier: CGFloat = 0.8
     
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: containerWidthMultiplier),
                        
            titleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24.0),
            titleStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24.0),
            titleStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -24.0),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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

    

}
