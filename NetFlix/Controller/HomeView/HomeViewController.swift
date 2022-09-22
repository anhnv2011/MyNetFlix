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

class HomeViewController: UIViewController {
    //    @IBOutlet weak var discoveryButtonWidth: NSLayoutConstraint!
    //    @IBOutlet weak var discoveryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var headerView: HeaderView?
    var lastVelocityYSign = 0
    let discoveryButton = DiscoveryButton()
    var discoveryState: DiscoveryState = . close
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupHeader()
        setupNavbar()
        //        let button = DiscoveryButton(frame: CGRect())
        setupDiscoveryButton()
        let sessionId = DataManager.shared.getSaveSessionId()

        print(sessionId)
    }
    
    
    //    @IBAction func buttonAction(_ sender: UIButton) {
    //        switch sender {
    //        case discoveryButton:
    //            print("")
    //        default:
    //            print("")
    //        }
    //    }
    
    func setupTableView(){
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blue
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        tableView.tableHeaderView = headerView
        
    }
    func setupHeader(){
        APICaller.share.getTrending(mediaType: "movie", time: "day") { (result) in
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
        //        title  = "Home"
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let profileButton =   UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didtapProfileButton))
        let playButton = UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
          profileButton,
            playButton
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didtapProfileButton(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var widthConstraint1: NSLayoutConstraint?
    var widthConstraint2: NSLayoutConstraint?
   
    func setupDiscoveryButton(){
        
        view.addSubview(discoveryButton)
        discoveryButton.configure(with: DiscoveryButtonViewModel(text: "Phim ngẫu nhiên",
                                                                 image: UIImage(systemName: "shuffle"),
                                                                 backgroundColor: .black))
        let tabBarHeight = self.tabBarController!.tabBar.intrinsicContentSize.height + 16
        
        discoveryButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, height: 56, bottomPadding: tabBarHeight, rightPadding: 8)
        discoveryButton.layer.cornerRadius = 28
        widthConstraint1 = discoveryButton.widthAnchor.constraint(equalToConstant: 56)
        widthConstraint2 = discoveryButton.widthAnchor.constraint(equalToConstant: 200)
        widthConstraint1?.isActive = true
        discoveryButton.addTarget(self, action: #selector(discoveryFilm), for: .touchUpInside)
        
    }
    
    @objc func discoveryFilm(){
        print("11")
      
       
    }
    
    func updateDiscoveryButton(){
       
        if discoveryState == .close {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
//                self.widthConstraint1?.isActive = false
//                self.widthConstraint2?.isActive = true
                self.widthConstraint1?.constant = 250
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
//                self.widthConstraint1?.isActive = true
//                self.widthConstraint2?.isActive = false
//                            self.view.layoutIfNeeded()
                
                self.widthConstraint1?.constant = 56
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
                
            })
        }
       
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        cell.delegate = self
        switch indexPath.section {
        case 0:
            APICaller.share.getTrending(mediaType: "all", time: "day") { result in
                switch result {
                case .success(let film):
                    cell.configCollectionView(with: film)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case 1:
            APICaller.share.getTrending(mediaType: "movie", time: "day") { result in
                switch result {
                case .success(let movie):
                    cell.configCollectionView(with: movie)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case 2:
            APICaller.share.getTrending(mediaType: "tv", time: "day") { result in
                switch result {
                case .success(let tv):
                    cell.configCollectionView(with: tv)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case 3:
            APICaller.share.getPopular(mediaType: "movie") { (result) in
                switch result {
                case .success(let movie):
                    cell.configCollectionView(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case 4:
            APICaller.share.getTopRate(mediaType: "movie") { (result) in
                switch result {
                case .success(let movie):
                    cell.configCollectionView(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            print("error")
        }
        
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        switch section {
    //        case 0:
    //            title = HomeSection.TrendingAll.title
    //        case 1:
    //            title = HomeSection.TrendingMovie.title
    //        case 2 :
    //            title = HomeSection.TrendingTv.title
    //        case 3:
    //            title = HomeSection.Popular.title
    //        case 4:
    //            title = HomeSection.TopRate.title
    //        default:
    //            print("error")
    //        }
    //        return title
    //    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HomeSection.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let defaultOffset = view.safeAreaInsets.top
//        print(defaultOffset)
//
//        let offset = scrollView.contentOffset.y + defaultOffset
//        print(scrollView.contentOffset.y)
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
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
    
}

extension HomeViewController: CollectionTableViewCellDelegate{
    func didTapCell(film: Film) {
        print(film)
        let vc = FilmDetailViewController()
        vc.view.backgroundColor = .clear
        vc.contenView.alpha = 1
        present(vc, animated: true, completion: nil)
    }
    
    
}
