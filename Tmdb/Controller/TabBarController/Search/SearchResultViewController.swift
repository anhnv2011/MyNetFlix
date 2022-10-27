//
//  SearchResultViewController.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit

class SearchResultViewController: UISearchController {

    public var films = [Film]()
    
    public let searchResultsCollectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
//    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.backgroundColor()
        setupCollectionView()
    }


    func setupCollectionView(){
        view.addSubview(searchResultsCollectionView)

        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    
}
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        
        let film = films[indexPath.row]
        cell.film = film
//        cell.configPosterImage(posterPath: film.poster_path ?? "")
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = FilmDetailPopUpViewController()
        var choseFilm = films[indexPath.row]
        print("choose", choseFilm.overview)
//        strongSelf.checkMovie(id: film.id!, posterPath: film.posterPath ?? "") { (isMovie) in
//            if isMovie == true {
//                film.mediaType = "movie"
//            } else {
//                film.mediaType = "tv"
//            }
//            print(film.mediaType)
//        }
        
        vc.completionDownload = {
            if let tabItems = self.tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = "New"
            }
        }
        checkMovie(id: choseFilm.id!, overview: choseFilm.overview!) { (isMovie) in
            if isMovie == true {
                choseFilm.mediaType = "movie"
            } else {
                choseFilm.mediaType = "tv"

            }
            print(choseFilm)
//            print(choseFilm.mediaType)
//            print("add more", choseFilm)
            vc.film = choseFilm
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .overFullScreen

                vc.view.backgroundColor = .clear
                self.present(vc, animated: true, completion: nil)
            }
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        DisplayCollectionCell.displayCollectionCell(cell: cell, indexPath: indexPath)
        
    }
}
extension UIViewController {
    func checkMovie(id: Int, overview: String, completion: @escaping ((Bool) -> ())){
        APICaller.share.movieDetailResponse(id: id) { (response) in
            switch response {
            case .success(let succes):
//                print("ssad", succes.overview)
                if succes.overview == overview {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(let error):
                self.makeBasicCustomAlert(title: "error", messaage: error.localizedDescription)
            }
        }
    }
}
