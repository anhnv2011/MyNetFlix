//
//  ToggleView.swift
//  NetFlix
//
//  Created by MAC on 9/16/22.
//

import Foundation
import UIKit

enum ToggleState: String, CaseIterable {
    case movie = "Movie"
    case tv = "Tv"
}

class ToggleView:UIView{

    var state: ToggleState = .movie
    {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.layoutIndicator()
            }
        }
    }
    
    private let movieButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Movies", for: .normal)
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
        view.backgroundColor = .black
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
        
        
        movieButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        tvsButton.frame = CGRect(x: movieButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
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
//        movieButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        tvsButton.frame = CGRect(x: movieButton.right, y: 0, width: 100, height: 40)
//        layoutIndicator()
    }

    func layoutIndicator() {
      
        if state == .movie {
            indicatorView.frame = CGRect(x: 0, y: movieButton.bottom, width: 100, height: 3)

            movieButton.setTitleColor(.blue, for: .normal)
            tvsButton.setTitleColor(.label, for: .normal)
        } else {
            indicatorView.frame = CGRect(x: 100, y: tvsButton.bottom, width: 100, height: 3)
            movieButton.setTitleColor(.label, for: .normal)
            tvsButton.setTitleColor(.blue, for: .normal)
        }
    }
    func update(for state: ToggleState) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
