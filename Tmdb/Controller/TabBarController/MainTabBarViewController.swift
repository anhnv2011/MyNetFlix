//
//  MainTabBarViewController.swift
//  Tmdb
//
//  Created by MAC on 6/26/22.
//

import UIKit
struct TabBarMenuItem {
    let title: String
    let icon: String
    let type: UIViewController.Type
}
class MainTabBarViewController: UITabBarController {
    static var menu: [TabBarMenuItem] {
        [
            TabBarMenuItem(title: "Home".localized(), icon: "house", type: HomeViewController.self),
            TabBarMenuItem(title: "Upcomming".localized(), icon: "play.circle", type: UpcommingViewController.self),
            TabBarMenuItem(title: "Download".localized(), icon: "square.and.arrow.down", type: DownloadViewController.self)
        ]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame.width)
        print(view.frame.height)
        setupUI()
        getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        setupTitle()
        setupIcon()
    }
    
    private func setupUI(){
        setupTabbar()
        setupTabbar()
    }
    
    private func setuNav(){
        
    }
    
    private func setupTabbar(){
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.naviBackground()
        self.tabBarController?.tabBar.backgroundColor = UIColor.tabbarBackground()
        self.tabBar.barTintColor = UIColor.tabbarBackground()
        self.tabBar.tintColor = UIColor.toggleButtonColor()
        setupViewControllers()
    
        
    }
    
    
    func setupIcon() {
        for (index, item) in (self.tabBar.items ?? []).enumerated() {
            item.image = UIImage(systemName: MainTabBarViewController.menu[index].icon)
                
        }
    }
    
    func setupTitle() {
        for (index, item) in (self.tabBar.items ?? []).enumerated() {
            item.title = MainTabBarViewController.menu[index].title
        }
    }
    
    private func setupViewControllers() {
        var viewControllers: [UIViewController] = []
        MainTabBarViewController.menu.forEach { item in
            viewControllers.append(UINavigationController(rootViewController: item.type.init()))
        }
        setViewControllers(viewControllers, animated: false)
    }
    func getProfileData(){
        APICaller.share.getCurrentProfile { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let profile):
                print("")
                DataManager.shared.profileData = profile
                DataManager.shared.saveProfileId(id: String(profile.id!))
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    
    
    
}
