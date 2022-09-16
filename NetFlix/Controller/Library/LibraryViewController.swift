//
//  LibraryViewController.swift
//  NetFlix
//
//  Created by MAC on 9/16/22.
//

import UIKit

class LibraryViewController: UIViewController{
    @IBOutlet weak var libraryScrollView: UIScrollView!
    
    let movieVC = MovieLibraryViewController()
    let tvShowVC = TvShowLibraryViewController()
    let toggleView = ToggleView()
    
    let widthScreen = UIScreen.main.bounds.width
    let heightScreen = UIScreen.main.bounds.height
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addChildView()
        setupToggle()
    }
    
    func setupScrollView(){
        libraryScrollView.backgroundColor = .yellow
        libraryScrollView.isPagingEnabled = true
        libraryScrollView.contentSize = CGSize(width: widthScreen * 2, height: heightScreen)
        libraryScrollView.delegate = self
    }

    func addChildView(){
        addChild(movieVC)
        libraryScrollView.addSubview(movieVC.view)
        movieVC.view.frame = CGRect(x: 0, y: 0, width: widthScreen, height: heightScreen)
        movieVC.didMove(toParent: self)
        addChild(tvShowVC)
        libraryScrollView.addSubview(tvShowVC.view)
        tvShowVC.view.frame = CGRect(x: widthScreen, y: 0, width: widthScreen, height: heightScreen)
        tvShowVC.didMove(toParent: self)
    }
    func setupToggle(){
        view.addSubview(toggleView)
        toggleView.frame = CGRect(x: 0, y: 100, width: 200, height: 55)
        toggleView.movieHandler = {
            self.libraryScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        toggleView.tvHandler = {
            
            self.libraryScrollView.setContentOffset(CGPoint(x: self.widthScreen, y: 0), animated: true)
        }
    }
    
}
extension LibraryViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100) {
            toggleView.update(for: .movie)
           
        }
        else {
            toggleView.update(for: .tv)
        }
    }
}
