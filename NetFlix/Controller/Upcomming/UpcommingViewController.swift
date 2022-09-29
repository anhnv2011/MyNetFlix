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
        cell.configDetailMovieTableCell(posterPath: path, name: name)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // initia state
        let rotationAngleRadius = 90 * CGFloat(.pi / 180.0)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleRadius, 0, 0, 1)
//        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        
        //defind final state after animation
        UIView.animate(withDuration: 1) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FilmDetailViewController()
        vc.view.backgroundColor = .clear
        vc.film = movie[indexPath.row]
        vc.mediaType = "movie"
        present(vc, animated: true, completion: nil)
    }
}


