//
//  UpcommingViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit


class UpcommingViewController: UIViewController {
    
    var movie = [Film]()
    var cellAimationFlag = [Int]()
    
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
        
        //        // initia state
        //        let rotationAngleRadius = 90 * CGFloat(.pi / 180.0)
        //        let rotationTransform = CATransform3DMakeRotation(rotationAngleRadius, 0, 0, 1)
        //        cell.layer.transform = rotationTransform
        //
        //        //defind final state after animation
        //        UIView.animate(withDuration: 1) {
        //            cell.layer.transform = CATransform3DIdentity
        //        }
        
        if cellAimationFlag.contains(indexPath.row) == false {
            // initia state
            cell.alpha = 0
            if indexPath.row % 2 == 0 {
                let transform = CATransform3DTranslate(CATransform3DIdentity, -500, 20, 0)
                cell.layer.transform = transform
                
            } else {
                let transform = CATransform3DTranslate(CATransform3DIdentity, 500, -200, 0)
                cell.layer.transform = transform
                
            }
            let value = Double(indexPath.row) / 10
            let delay = min(1, value)
            print(delay)
            UIView.animate(withDuration: 1, delay: TimeInterval(delay), options: .curveEaseIn) {
               
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            } completion: { (_) in
                
            }
            cellAimationFlag.append(indexPath.row)
        }
        
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FilmDetailPopUpViewController()
        
        var choseFilm = movie[indexPath.row]
        choseFilm.media_type = "movie"
        print(choseFilm)
        vc.film = choseFilm
        vc.view.backgroundColor = .clear
        present(vc, animated: true, completion: nil)
    }
}


