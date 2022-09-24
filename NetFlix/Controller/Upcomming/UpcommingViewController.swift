//
//  UpcommingViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

enum Comming {
    case Movie(model: [Film])
    case Tv (model: [Film])
    var tittle: String {
        switch self {
        case .Movie:
            return "UpComming Movie"
        case .Tv:
            return "UpComming TV"
        }
    }
}

class UpcommingViewController: UIViewController {

    var comming:[Comming] = []
    var movie = [Film]()
    var upcomming = [UpComming]()
    
    @IBOutlet weak var upCommingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
   
    
    }
    func fetchData(){
        APICaller.share.getUpcomming(mediaType: "movie") { (result) in
            switch result {
            case.success(let model):
              
                self.movie = model.results
                let dateTitle = "From: " + model.dates.minimum + "  to " + model.dates.maximum
                DispatchQueue.main.async {
                    self.navigationItem.title = dateTitle
                    self.upCommingTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
//        APICaller.share.getUpcomming(mediaType: "tv") { (result) in
//            switch result {
//            case.success(let tv):
//                self.comming.append(.Tv(model: tv))
//            case .failure(let error):
//                print(error.localizedDescription)
//                
//            }
//        }
    }

    func setupTableView(){
        upCommingTableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: "UpCommingTableViewCell")
        upCommingTableView.delegate = self
        upCommingTableView.dataSource = self
    }
   

}

extension UpcommingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upCommingTableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell", for: indexPath) as! UpCommingTableViewCell
        let currentmovie = movie[indexPath.row]
        let path = currentmovie.poster_path
        let name = (currentmovie.original_name ?? currentmovie.original_title) ?? "unknow"
        cell.configDetailMovieTableCell(posterPath: path!, name: name)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
