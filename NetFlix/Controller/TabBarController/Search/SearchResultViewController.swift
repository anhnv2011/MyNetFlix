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

        view.backgroundColor = .systemBackground
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
            UIView.animate(withDuration: 1, delay: TimeInterval(delay), options: .curveEaseIn) {
               
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            } completion: { (_) in
                
            }
           
        
    }
}
