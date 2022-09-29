//
//  HeaderView.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit
import SDWebImage
class HeaderView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        //imageView.image = UIImage(named: "netflixLogo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    override func layoutSubviews() {
        imageView.frame = bounds
    }
    func configHeader(posterPath: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else {
            return
        }
        imageView.sd_setImage(with: url, completed: nil)
    }
}
