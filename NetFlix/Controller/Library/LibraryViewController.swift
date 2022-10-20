//
//  LibraryViewController.swift
//  NetFlix
//
//  Created by MAC on 9/16/22.
//

import UIKit
enum LibraryType {
    case favorite
    case watchlist
    case lists
    case rate
    var title: String {
        switch self {
        case .favorite:
            return "Favorite".localized()
        case .watchlist:
            return "Watch List".localized()
        case .lists:
            return "Lists".localized()
        case .rate:
            return "Rate".localized()
        }
    }
}

class LibraryViewController: UIViewController{
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK:- Outlet
    @IBOutlet weak var topView: UIView!
    
    var libraryType: LibraryType = .favorite
    
    //MARK:- Property
    var state: ToggleState = .movie

    let toggleView = ToggleView()
    
    let widthScreen = UIScreen.main.bounds.width
    let heightScreen = UIScreen.main.bounds.height
    
    
    var moviesData = [Film]()
    {
        didSet{
            DispatchQueue.main.async { [self] in
                self.setupUI()
                collectionView.reloadData()
            }
        }
    }
    var tvsData = [Film]()
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetData()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK:- UI
    private func setupUI(){
        navigationController?.hidesBarsOnSwipe = false
        setupTittle()
        setupToggle()
        setupPositionView()
        setupCollectionView()
    }
    
    
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LibraryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
//        setupPositionView()
        
    }
    private func setupTittle(){
        title = libraryType.title
    }
    
    func setupToggle(){
        topView.addSubview(toggleView)
        
        toggleView.frame = topView.bounds
        //        toggleView.frame = CGRect(x: 0, y: 100, width: 200, height: 55)
        toggleView.movieHandler = {
            self.collectionView.setContentOffset(CGPoint(x: 0,
                                                         y: 0),
                                                 animated: true)
        }
        toggleView.tvHandler = {
            self.collectionView.setContentOffset(CGPoint(x: self.widthScreen,
                                                         y: 0),
                                                 animated: true)
        }
    }
    
    func setupPositionView(){
        if state == .movie {
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            toggleView.state = .movie
            
        } else if state == .tv {
            collectionView.setContentOffset(CGPoint(x: self.widthScreen ,
                                                    y: 0), animated: true)
            
            view.layoutIfNeeded()
//
//            collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionView.ScrollPosition.right, animated: false)
            toggleView.state = .tv
        }
    }
    
    
    //MARK:- Fetch Data
    private func fetData(){
        if libraryType == .favorite {
           
            getmovieFavorite()
            getTVFavorite()
        } else if libraryType == .watchlist {
            
            getTVWatchList()
            getMovieWatchList()
        } else if libraryType == .lists {
            
        } else {
            
            getRateMovieList()
            getRateTVList()
        }
    }
    
}



//MARK:- Favorite function
extension LibraryViewController{
    
    
    func getmovieFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getMovieFavorite(sessonid: sessionid, profileID: profileid) { [weak self] response in
            guard let strongSelf = self else {return}
            switch response {
            case . success(let films):
                
                strongSelf.moviesData = films
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    func getTVFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getTVFavorite(sessonid: sessionid, profileID: profileid) { [weak self] response in
            guard let strongSelf = self else {return}
            
            switch response {
            case . success(let films):
                strongSelf.tvsData = films
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//MARK:- WatchList function
extension LibraryViewController {
    
    
    func getMovieWatchList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getWatchList(mediaType: "movies", sessonid: sessionid, profileID: profileid) { [weak self] (response) in
            guard let strongSelf = self else {return}
            
            switch response {
            case . success(let films):

                strongSelf.moviesData = films
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func getTVWatchList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getWatchList(mediaType: "tv", sessonid: sessionid, profileID: profileid) { [weak self] (response) in
            guard let strongSelf = self else {return}
            
            switch response {
            case . success(let films):
                strongSelf.tvsData = films
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


//MARK:- Rate Func
extension LibraryViewController{
    func getRateMovieList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        
        APICaller.share.getRate(mediaType: "movies", profileID: profileid, sessionID: sessionid) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let films):
                strongSelf.moviesData = films
                
            case .failure(let error):
                self!.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    func getRateTVList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        
        APICaller.share.getRate(mediaType: "tv", profileID: profileid, sessionID: sessionid) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let films):
                
                strongSelf.tvsData = films
                
            case .failure(let error):
                self!.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
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
        
    }
}


extension LibraryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as! LibraryCollectionViewCell
        cell.type = self.libraryType
        cell.completionToRoot = { [weak self] in
             self?.navigationController?.popToRootViewController(animated: true)
        }
        cell.completionShow = { [weak self] film in
            
            self?.showFilmPopupDetail(film: film)
        }
        
        if indexPath.row == 0 {
            cell.films = moviesData
            
        } else if indexPath.row == 1 {
            cell.films = tvsData
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    
    private func showFilmPopupDetail(film: Film){
        let vc = FilmDetailPopUpViewController()
        vc.completion = {
            if let tabItems = self.tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = "New"
            }
        }
        vc.film = film
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
