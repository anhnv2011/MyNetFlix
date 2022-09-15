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
    
    //let search:uise
    override func viewDidLoad() {
        super.viewDidLoad()

        searchMovieBar.delegate = self
//        searchMovieBar.searchResultsUpdater
        
    }

    func setUpTableView(){
        
    }

    

}
extension SearchViewController: UISearchBarDelegate {
    
}
