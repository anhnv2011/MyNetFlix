//
//  ToggleView.swift
//  NetFlix
//
//  Created by MAC on 9/16/22.
//

import Foundation
import UIKit
class ToggleView:UIView{
    
    enum State {
        case movie
        case tv
    }

    var state: State = .movie
    
    private let movieButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("movies", for: .normal)
        return button
    }()

    private let tvsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("TV Show", for: .normal)
        return button
    }()

    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    var movieHandler: (() -> Void)?
    var tvHandler : (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieButton)
        addSubview(tvsButton)
        addSubview(indicatorView)
        movieButton.addTarget(self, action: #selector(didTapmovies), for: .touchUpInside)
        tvsButton.addTarget(self, action: #selector(didTaptvs), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didTapmovies() {
        state = .movie
        UIView.animate(withDuration: 0.2) {
            
            self.layoutIndicator()
        }
        movieHandler!()
    }

    @objc private func didTaptvs() {
        state = .tv
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
       tvHandler!()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        movieButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        tvsButton.frame = CGRect(x: movieButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }

    func layoutIndicator() {
      
        if state == .movie {
            indicatorView.frame = CGRect(x: 0, y: movieButton.bottom, width: 100, height: 3)
        } else {
            indicatorView.frame = CGRect(x: 100, y: movieButton.bottom, width: 100, height: 3)
        }
    }
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
extension UIView {
    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return left + width
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }
}
