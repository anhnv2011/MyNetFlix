//
//  MainTabBarViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //print(DataManager.shared.SessionId)
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcommingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
//        let vc3 = SearchViewController()

        let vc4 = UINavigationController(rootViewController: DownloadViewController())
        
        vc1.title = "Home"
        vc2.title = "Upcomming"
        vc3.title = "Search"
        vc4.title = "Download"
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        
        setViewControllers([vc1,vc2, vc3, vc4], animated: true)

    }
    

   

}
