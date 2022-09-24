//
//  SearchViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchMovieBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    private var films: [Film] = [Film]()
    
    //let search:uise
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDiscoverMovies()
        setUpTableView()
//        searchMovieBar.searchResultsUpdater
        setupSearchBar()
        
    }

    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpCommingTableViewCell")
    }
    
    func setupSearchBar(){
        searchMovieBar.delegate = self
        searchMovieBar.placeholder =  "Search for a Movie or a Tv show"
        searchMovieBar.searchBarStyle = .minimal

    }

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
extension SearchViewController: UISearchBarDelegate {
    
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell", for: indexPath) as! UpCommingTableViewCell
        let film = films[indexPath.row]
        cell.configDetailMovieTableCell(posterPath: film.poster_path ?? "", name: film.original_name ?? film.original_title ?? "Unknown name" )
        
       
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        

    }
}
