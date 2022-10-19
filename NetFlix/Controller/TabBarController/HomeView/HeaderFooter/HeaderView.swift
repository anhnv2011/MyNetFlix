//
//  HeaderView.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit
import SDWebImage

class HeaderView: UIView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        //imageView.image = UIImage(named: "netflixLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    public let inforButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.setImage(UIImage(systemName: "info.circle"), for: .highlighted)
        button.tintColor = .white
        return button
    }()
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()

    var film:Film!
  
    var completion: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        setViewConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(){
        backgroundColor = UIColor.viewBackground()
    }
    
    func createView(){
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(inforButton)
    }
    func setViewConstraints(){
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        
        ])
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        
        inforButton.anchor(bottom: containerView.bottomAnchor, right: containerView.rightAnchor, width: 56, height: 56, bottomPadding: 24, rightPadding: 24)
        inforButton.addTarget(self, action: #selector(getInfor), for: .touchUpInside)
    }
    
    @objc func getInfor(){
        completion!()
    }
//    override func layoutSubviews() {
//        imageView.frame = bounds
//    }
    func configHeader(posterPath: String) {
        let url =  "https://image.tmdb.org/t/p/w500/\(posterPath)"
        imageView.loadImageUsingCache(url)
    }
    
    
    
    /// Notify view of scroll change from container
    public func scrollViewDidScroll(scrollView: UIScrollView) {
//        containerViewHeight.constant = scrollView.contentInset.top
//        print(scrollView.contentOffset.y)
//        print(scrollView.contentInset.top)
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
//        imageViewBottom.constant = offsetY >= 0 ? 0 : offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
