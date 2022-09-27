//
//  CollectionTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit
import RxCocoa
import RxSwift
protocol CollectionTableViewCellDelegate:AnyObject {
    func didTapCell(film: Film)
}

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var films:[Film] = []
//    var films = PublishSubject<[Film]>()
    private let disposeBag = DisposeBag()


    var delegate: CollectionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 140, height: 200)
//        layout.scrollDirection = .horizontal
//
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
    setupCollectionView()
        
//        binddata()
       
    }
//    func binddata(){
//        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
//        films.bind(to: collectionView.rx.items(cellIdentifier: "CollectionViewCell", cellType: CollectionViewCell.self)) {  (row,film,cell) in
////            cell.album = album
////            cell.withBackView = true
//                
//            cell.configPosterImage(posterPath: film.poster_path)
//            }.disposed(by: disposeBag)
//    }

    func setupCollectionView(){
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    func configCollectionView(with films: [Film]){
        self.films = films
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }


    }
    
}
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


//extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

        let path = films[indexPath.row].poster_path


        cell.configPosterImage(posterPath: path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
//        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
//        let realCenter = collectionView.convert(attributes!.frame, to: collectionView.superview?.superview?.superview?.superview)
//        print(realCenter)

        let film = films[indexPath.row]
        delegate?.didTapCell(film: film)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil) { () -> UIViewController? in
            return PreviewViewController()
        } actionProvider: { _ -> UIMenu? in
            let yourlistAction = UIAction(title: "Your list", image: UIImage(systemName: "list.dash"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                print("Your list")
                }
            let favoriteAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                print("Favorite")
                }
            
            let watchListAction = UIAction(title: "Watch list", image: UIImage(systemName: "bookmark.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                print("Watch list")
                }
            let rateItAction = UIAction(title: "Rate it", image: UIImage(systemName: "star.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                print("Rate it")
                }
            let playTrailerAction = UIAction(title: "Play Trailer", image: UIImage(systemName: "play.circle.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                print("Play Trailer")
                }
           
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [yourlistAction, favoriteAction, watchListAction, rateItAction, playTrailerAction])
        }


//        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
//
////
//            let yourlistAction = UIAction(title: "Your list", image: UIImage(systemName: "list.dash"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Your list")
//                }
//            let favoriteAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Favorite")
//                }
//
//            let watchListAction = UIAction(title: "Watch list", image: UIImage(systemName: "bookmark.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Watch list")
//                }
//            let rateItAction = UIAction(title: "Rate it", image: UIImage(systemName: "star.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Rate it")
//                }
//            let playTrailerAction = UIAction(title: "Play Trailer", image: UIImage(systemName: "play.circle.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Play Trailer")
//                }
//
//            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [yourlistAction, favoriteAction, watchListAction, rateItAction, playTrailerAction])
//        }
        return config
    }
}
