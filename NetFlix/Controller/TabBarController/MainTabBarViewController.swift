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

        setupTabbar()
        getProfileData()
    }
    
    func setupTabbar(){
//        print(DataManager.shared.getSaveSessionId())
//        print(DataManager.shared.getProfileId())
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcommingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadViewController())
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .black

        vc1.title = "Home"
        vc2.title = "Upcomming"
        vc3.title = "Search"
        vc4.title = "Download"
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        
        self.tabBarController?.tabBar.backgroundColor = .black
        self.tabBar.barTintColor = .black
        self.tabBar.tintColor = .blue
        setViewControllers([vc1,vc2, vc3, vc4], animated: true)
    }
    
    func getProfileData(){
                APICaller.share.getCurrentProfile { [weak self] result in
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let profile):
                        print("")
                        DataManager.shared.profileData = profile
                        DataManager.shared.saveProfileId(id: String(profile.id!))
//                        strongSelf.getmovieFavorite()
//                        strongSelf.getTVFavorite()
//                        strongSelf.getMovieWatchList()
//                        strongSelf.getTVWatchList()
        
                    case .failure(let error):
                        strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
                    }
                }
    }
   
    func getmovieFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getMovieFavorite(sessonid: sessionid, profileID: profileid) { response in
            switch response {
            case . success(let film):
                DataManager.shared.favoriteMovie = film
            case .failure(let error):
                print(error)
            }
        }
    }
    func getTVFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getTVFavorite(sessonid: sessionid, profileID: profileid) { response in
            switch response {
            case . success(let film):
                DataManager.shared.favoriteTv = film
            case .failure(let error):
                print(error)
            }
        }
    }
    func getMovieWatchList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getWatchList(mediaType: "movies", sessonid: sessionid, profileID: profileid) { (response) in
            switch response {
            case . success(let film):
                print(film)
                DataManager.shared.watchListMovie = film
            case .failure(let error):
                print(error)
            }
        }
    }
    func getTVWatchList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getWatchList(mediaType: "tv", sessonid: sessionid, profileID: profileid) { (response) in
            switch response {
            case . success(let film):
                print(film)
                DataManager.shared.watchListTv = film
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
