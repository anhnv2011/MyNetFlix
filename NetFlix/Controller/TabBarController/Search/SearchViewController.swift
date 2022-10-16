//
//  SearchViewController.swift
//  NetFlix
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
    
    //MARK:- UI
    private func setupUI(){
        setupNavigation()
        setupTableView()
        setupSearchBar()
        
    }
    func setupNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = UIColor.labelColor()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        
        title = "Search"
        navigationItem.searchController = searchController
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpCommingTableViewCell")
    }
    
    func setupSearchBar(){
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        //text in search box
        searchController.searchBar.searchTextField.textColor = UIColor.labelColor()
        
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
        let film = films[indexPath.row]
        cell.configDetailMovieTableCell(posterPath: film.poster_path , name: film.original_name ?? film.original_title ?? "Unknown name" )
        
        
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellAimationFlag.contains(indexPath.row) == false {
            // initia state
            DisplayTableCell.displayTableCell(cell: cell, indexPath: indexPath)
            cellAimationFlag.append(indexPath.row)
        }
    }
}
