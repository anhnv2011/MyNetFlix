//
//  CollectionTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit

protocol CollectionTableViewCellDelegate:AnyObject {
    func didTapCell(film: Film, tableCellNumber: Int)
}

class CollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
 
    var films:[Film] = []
    var sectionInTable:Int = 0
    
    var tableCellNumber = 0
    
    
    var delegate: CollectionTableViewCellDelegate?
    var previewCompletion: ((IndexPath, Int)->Void)?
    var showInforCompletion: ((Film, Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        
        
    }
    
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
        
        let film = films[indexPath.row]
        cell.film = film
        
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
        
        delegate?.didTapCell(film: film, tableCellNumber: tableCellNumber)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        //        let identifier = films[indexPath.row].original_name
        
       
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath) { [weak self] () -> UIViewController? in
            return PlayerViewController(film: self!.films[indexPath.row])
        } actionProvider: { _ -> UIMenu? in
            
        
            let yourlistAction = UIAction(title: "Show information".localized(), image: UIImage(systemName: "list.dash")?.withTintColor(.red, renderingMode: .automatic), identifier: nil, discoverabilityTitle: nil, state: .off){ [weak self] _ in
                guard let strongSelf = self else {return}
                let film = strongSelf.films[indexPath.row]

                strongSelf.showInforCompletion!(film, strongSelf.sectionInTable)
            }
//            let favoriteAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Favorite")
//            }
//
//            let watchListAction = UIAction(title: "Watch list", image: UIImage(systemName: "bookmark.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Watch list")
//            }
//            let rateItAction = UIAction(title: "Rate it", image: UIImage(systemName: "star.fill"), identifier: nil, discoverabilityTitle: nil, state: .off){_ in
//                print("Rate it")
//            }
            
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [yourlistAction])
        }
        
        
       
        return config
    }
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
      
        guard let indexPath = configuration.identifier as? IndexPath else { return }
        previewCompletion!(indexPath, sectionInTable)
        
    }
    
    
}
