//
//  DownloadViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

class DownloadViewController: UIViewController {
    
    
    @IBOutlet weak var downloadTableView: UITableView!
    
    var filmItems = [FilmItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNotification()
        fetchLocalStorageForDownload()
    }
    func setupNotification(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    private func fetchLocalStorageForDownload() {

        
        DataPersistenceManager.shared.fetchingFilmsFromDataBase { [weak self] result in
            
            
            switch result {
            case .success(let filmItems):
                print(filmItems)
                self?.filmItems = filmItems
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func setupUI(){
        setupTabbar()
        setupNav()
    }
    
    func setupTableView(){
        downloadTableView.dataSource = self
        downloadTableView.delegate = self
        downloadTableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: UpCommingTableViewCell.identifier)
    }
    func setupNav(){
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    func setupTabbar(){
        if let tabItems = tabBarController?.tabBar.items {
            // modify the badge number of the third tab:
            let tabItem = tabItems[3]
            tabItem.badgeValue = nil
        }
    }
}

extension DownloadViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filmItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = downloadTableView.dequeueReusableCell(withIdentifier: UpCommingTableViewCell.identifier, for: indexPath) as! UpCommingTableViewCell
        let film = filmItems[indexPath.row]
        let poster = film.poster_path
        let name = film.original_name != nil ? film.original_name : film.original_title
        cell.configDetailMovieTableCell(posterPath: poster!, name: name!)
        
        return cell
    }
    
    
}
