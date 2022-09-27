//
//  HomeViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

enum DiscoveryState{
    case close
    case expanse
}

enum HomeSection {
    case trendingAll(model: [Film])
    case trendingMovie(model: [Film])
    case trendingTv(model: [Film])
    case popularMovie(model: [Film])
    case popularTv(model: [Film])
    case topRateMovie(model: [Film])
    case topRateTV(model: [Film])
    var title: String {
        switch self {
        case .trendingAll:
            return "Trending"
        case .trendingMovie:
            return "Trending Movie"
        case .trendingTv:
            return "Trending TV"
        case .popularMovie:
            return "Popular Movie"
        case .popularTv:
            return "Popular TV"
        case .topRateMovie:
            return "Top Rate Movie"
        case .topRateTV:
            return "Top Rate TV"
        
        }
    }

}

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var homeSection = [HomeSection]()
  
    
    var headerView: HeaderView?
    var lastVelocityYSign = 0
    let discoveryButton = DiscoveryButton()
    var discoveryState: DiscoveryState = . close
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sessionid = DataManager.shared.getSaveSessionId()
        print(sessionid)
//        setupTableView()
//        setupHeader()
//        setupNavbar()
//        setupDiscoveryButton()
//        fetchData()

        APICaller.share.postFavorite()
        
    }
   
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        APICaller.share.getTrending(mediaType: .all, time: .day) { [weak self] result in
            
            defer {
                group.leave()
            }
            switch result {
            case .success(let movie):
                self?.homeSection.append(.trendingAll(model: movie))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        group.enter()
        APICaller.share.getTrending(mediaType: .movie, time: .day) { [weak self] result in
            
            defer {
                group.leave()
            }
            switch result {
            case .success(let movie):
                self?.homeSection.append(.trendingMovie(model: movie))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        group.enter()
        APICaller.share.getTrending(mediaType: .tv, time: .day) { [weak self] result in
            
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let tv):
                self?.homeSection.append(.trendingTv(model: tv))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        group.enter()

        APICaller.share.getPopular(mediaType: .movie) { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let movie):
                self?.homeSection.append(.popularMovie(model: movie))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.enter()

        APICaller.share.getPopular(mediaType: .tv) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let tv):
                self?.homeSection.append(.popularTv(model: tv))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.enter()

        APICaller.share.getTopRate(mediaType: .movie) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let movie):
                self?.homeSection.append(.topRateMovie(model: movie))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.enter()

        APICaller.share.getTopRate(mediaType: .tv) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let tv):
                self?.homeSection.append(.topRateTV(model: tv))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
       
    }

    
    func setupTableView(){
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
        tableView.tableHeaderView = headerView
        
    }
    func setupHeader(){
        APICaller.share.getTrending(mediaType: .movie, time: .day) { (result) in
            switch result {
            case .success(let movie):
                let random = movie.randomElement()
                DispatchQueue.main.async {
                    self.headerView?.configHeader(posterPath: random?.poster_path ?? "")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavbar() {
                title  = "Home"

        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let profileButton =   UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didtapProfileButton))
        let playButton = UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
          profileButton,
            playButton
        ]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]


    }
    
    @objc func didtapProfileButton(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var widthConstraint1: NSLayoutConstraint?
   
    func setupDiscoveryButton(){
        
        view.addSubview(discoveryButton)
        discoveryButton.configure(with: DiscoveryButtonViewModel(text: "Phim ngẫu nhiên",
                                                                 image: UIImage(systemName: "shuffle"),
                                                                 backgroundColor: .black))
        let tabBarHeight = self.tabBarController!.tabBar.intrinsicContentSize.height + 16
        
        discoveryButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, height: 56, bottomPadding: tabBarHeight, rightPadding: 8)
        discoveryButton.layer.cornerRadius = 28
        widthConstraint1 = discoveryButton.widthAnchor.constraint(equalToConstant: 56)
        widthConstraint1?.isActive = true
        discoveryButton.addTarget(self, action: #selector(discoveryFilm), for: .touchUpInside)
        
    }
    
    @objc func discoveryFilm(){
        print("11")
      
       
    }
    
    func updateDiscoveryButton(){
       
        if discoveryState == .close {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {

                self.widthConstraint1?.constant = 250
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {

                
                self.widthConstraint1?.constant = 56
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
                
            })
        }
       
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return HomeSection.allCases.count
        return homeSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        cell.delegate = self
        
        let type = homeSection[indexPath.section]
        switch type {
        case .trendingAll(model: let model):
            cell.films = model
        case .trendingMovie(model: let model):
            cell.films = model
        case .trendingTv(model: let model):
            cell.films = model
        case .popularMovie(model: let model):
            cell.films = model
        case .popularTv(model: let model):
            cell.films = model
        case .topRateMovie(model: let model):
            cell.films = model
        case .topRateTV(model: let model):
            cell.films = model
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return HomeSection.allCases[section].title
        return homeSection[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let defaultOffset = view.safeAreaInsets.top
//        print(defaultOffset)
//
        let offset = scrollView.contentOffset.y + defaultOffset
//        print(scrollView.contentOffset.y)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        if currentVelocityYSign != lastVelocityYSign &&
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        if self.lastVelocityYSign < 0 {
            discoveryState = .expanse
            updateDiscoveryButton()
            //print("SCROLLING DOWN")
        } else if self.lastVelocityYSign > 0 {
            discoveryState = .close
            updateDiscoveryButton()
            
            // print("SCOLLING UP")
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
}

extension HomeViewController: CollectionTableViewCellDelegate{
    func didTapCell(film: Film) {
        print(film)
        let vc = FilmDetailViewController()
        vc.view.backgroundColor = .clear
//        vc.contenView.alpha = 0.5
        present(vc, animated: true, completion: nil)
    }
    
    
}
