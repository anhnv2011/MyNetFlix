//
//  LibraryViewController.swift
//  NetFlix
//
//  Created by MAC on 9/16/22.
//

import UIKit

class LibraryViewController: UIViewController{
   
    //MARK:- Outlet
    @IBOutlet weak var libraryScrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    
    //MARK:- Property
    var state: ToggleState = .movie
    
    let movieVC = MovieLibraryViewController()
    let tvShowVC = TvShowLibraryViewController()
    let toggleView = ToggleView()
    
    let widthScreen = UIScreen.main.bounds.width
    let heightScreen = UIScreen.main.bounds.height
    

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK:- UI
    private func setupUI(){
        setupScrollView()
        addChildView()
        setupToggle()
        setupPositionView()
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
        tvShowVC.view.frame = CGRect(x: widthScreen,
                                     y: 0,
                                     width: widthScreen,
                                     height: heightScreen)
        tvShowVC.didMove(toParent: self)
    }
    func setupToggle(){
        topView.addSubview(toggleView)
        
        toggleView.frame = topView.bounds
//        toggleView.frame = CGRect(x: 0, y: 100, width: 200, height: 55)
        toggleView.movieHandler = {
            self.libraryScrollView.setContentOffset(CGPoint(x: 0,
                                                            y: 0),
                                                    animated: true)
        }
        toggleView.tvHandler = {
            self.libraryScrollView.setContentOffset(CGPoint(x: self.widthScreen,
                                                            y: 0),
                                                    animated: true)
        }
    }
    
    func setupPositionView(){
        if state == .movie {
            libraryScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            toggleView.state = .movie

        } else if state == .tv {
            libraryScrollView.setContentOffset(CGPoint(x: self.widthScreen,
                                                       y: 0), animated: true)
            toggleView.state = .tv
        }
    }
    
}

    //MARK:- Scroll Delegate
extension LibraryViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x >= (view.width) {
            if self.state == .movie {
                toggleView.update(for: .tv)
                self.state = .tv
            }
        }
        if scrollView.contentOffset.x == 0 {
            if self.state == .tv {
                toggleView.update(for: .movie)
                self.state = .movie
            }
        }
//        else {
//            toggleView.update(for: .movie)
//        }
    }
}
