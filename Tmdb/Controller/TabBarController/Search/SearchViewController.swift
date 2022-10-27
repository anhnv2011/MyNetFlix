//
//  SearchViewController.swift
//  Tmdb
//
//  Created by MAC on 6/26/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var films: [Film] = [Film]()
    var cellAimationFlag = [Int]()
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show".localized()
        return controller
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchDiscoverMovies()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupNavigation()
    }
    
    //MARK:- UI
    private func setupUI(){
        setupNavigation()
        setupTableView()
        setupSearchBar()
        
    }
    
    
    func setupNavigation(){
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.tintColor = UIColor.labelColor()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        
        title = "Search"
        navigationItem.searchController = searchController
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: UpCommingTableViewCell.identifier)
    }
    
    func setupSearchBar(){
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        //text in search box
        searchController.searchBar.searchTextField.textColor = UIColor.labelColor()
        navigationItem.hidesSearchBarWhenScrolling = false

        
    }
    
    //MARK:- FetchData
    private func fetchDiscoverMovies() {
        APICaller.share.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let films):
                self?.films = films
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        APICaller.share.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    resultsController.films = films
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension SearchViewController:UISearchBarDelegate {
    
}

//MARK:- Table View delegate, dataSource
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell", for: indexPath) as! UpCommingTableViewCell
        cell.completionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            let transiton = TransitionDelegate()
            let film = strongSelf.films[indexPath.row]
            
            
            let vc = PlayerViewController(film: film)
//            vc.film = strongSelf.films[indexPath.row]
            
            vc.transitioningDelegate = transiton
            vc.modalPresentationStyle = .fullScreen
            strongSelf.present(vc, animated: true, completion: nil)
        }
        let film = films[indexPath.row]
//        let name = film.originalTitle != nil ? film.originalTitle : film.originalName
        cell.film = film
//        cell.configDetailMovieTableCell(posterPath: film.posterPath! , name:  name!)
        
        
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FilmDetailPopUpViewController()
        vc.completionDownload = {
            if let tabItems = self.tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = "New"
            }
        }
        var choseFilm = films[indexPath.row]
        choseFilm.mediaType = "movie"
        vc.film = choseFilm
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = .clear
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellAimationFlag.contains(indexPath.row) == false {
            // initia state
            DisplayTableCell.displayTableCell(cell: cell, indexPath: indexPath)
            cellAimationFlag.append(indexPath.row)
        }
    }
    
    
    func checkTV(id: Int, originTitle: String, completion: @escaping ((Bool) -> ())){
       
        APICaller.share.tvDetailResponse(id: id) { (response) in
            switch response {
            case .success(let data):
                if data.episodeRunTime != nil {
                    completion(true)
                } else {
                    print("")
                }
            case .failure(let error):
                self.makeBasicCustomAlert(title: "error", messaage: error.localizedDescription)
            }
        }
    }
}


