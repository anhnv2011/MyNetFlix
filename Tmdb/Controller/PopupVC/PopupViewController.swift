//
//  PopupViewController.swift
//  Tmdb
//
//  Created by MAC on 10/3/22.
//

import UIKit

protocol PopupViewControllerDelegate: AnyObject {
    
    
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController)
}


class PopupViewController: UIViewController {
    
    public enum PopupPosition {
        case center(CGPoint?)
        case offsetFromView(CGPoint? = nil, UIView)
    }
    
    
    var popupWidth: CGFloat?
    var popupHeight: CGFloat?
    var position: PopupPosition = .center(nil)
    var backgroundAlpha: CGFloat = 0.2
    var backgroundColor = UIColor.label
    var canTapOutsideToDismiss = true
    var cornerRadius: CGFloat = 0
    var shadowEnabled = true
    var contentController: UIViewController?
    var contentView: UIView?
    
    weak var delegate: PopupViewControllerDelegate?
    
    private var containerView = UIView()
    private var isViewDidLayoutSubviewsCalled = false
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(contentController: UIViewController, position: PopupPosition = .center(nil), popupWidth: CGFloat?, popupHeight: CGFloat?) {
        super.init(nibName: nil, bundle: nil)
        self.contentController = contentController
        self.contentView = contentController.view
        self.popupWidth = popupWidth
        self.popupHeight = popupHeight
        self.position = position
        
        commonInit()
    }
    
  
    private func commonInit() {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
////        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addDismissGesture()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isViewDidLayoutSubviewsCalled == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupViews()
            }
        }
        
        isViewDidLayoutSubviewsCalled = true
    }
    
    // MARK: - Setup

    private func addDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapGesture(gesture:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = backgroundColor.withAlphaComponent(backgroundAlpha)
        
        if cornerRadius > 0 {
            contentView?.layer.cornerRadius = cornerRadius
            contentView?.layer.masksToBounds = true
        }
        
        if shadowEnabled {
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowColor = UIColor.label.cgColor
            containerView.layer.shadowRadius = 3
        }
    }
    
    private func setupViews() {
        if let contentController = contentController {
            addChild(contentController)
        }
        
        addViews()
        addSizeConstraints()
        addPositionConstraints()
    }
    
    private func addViews() {
        view.addSubview(containerView)
        
        if let contentView = contentView {
            containerView.addSubview(contentView)
            
            [
                contentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
                contentView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
                contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
                contentView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0)
            ].forEach({$0.isActive = true})
        }
    }
    
    // MARK: - Add constraints
    
    private func addSizeConstraints() {
        if let popupWidth = popupWidth {

            let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: popupWidth)
            widthConstraint.isActive = true
        }
        
        if let popupHeight = popupHeight {
            let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: popupHeight)
            heightConstraint.isActive = true
        }
    }
    
    private func addPositionConstraints() {
        switch position {
        case .center(let offset):
            addCenterPositionConstraints(offset: offset)
        case .offsetFromView(let offset, let anchorView):
            addOffSetConstraints(offset: offset, anchorView: anchorView)
        }
    }
    
    private func addCenterPositionConstraints(offset: CGPoint?) {
        let centerXConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: offset?.x ?? 0)
        let centerYConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: offset?.y ?? 0)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }
    
    private func addOffSetConstraints(offset: CGPoint?, anchorView: UIView?) {
        var position: CGPoint = offset ?? .zero
        
        if let anchorView = anchorView {
            let anchorViewPosition = view.convert(CGPoint.zero, from: anchorView)
            position = CGPoint(x: position.x + anchorViewPosition.x, y: position.y + anchorViewPosition.y)
        }
        
        let topConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: position.y)
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: position.x)
        NSLayoutConstraint.activate([topConstraint, leftConstraint])
    }
    
   

    // MARK: - Actions
    
    @objc func dismissTapGesture(gesture: UIGestureRecognizer) {
        dismiss(animated: true) {
            self.delegate?.popupViewControllerDidDismissByTapGesture(self)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PopupViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view, canTapOutsideToDismiss else {
            return false
        }
        
        return !touchView.isDescendant(of: containerView)
    }
}
