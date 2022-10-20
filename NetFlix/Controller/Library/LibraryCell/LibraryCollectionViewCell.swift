//
//  LibraryCollectionViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/20/22.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {
    static let identifier = "LibraryCollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    var type: LibraryType!
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setupUI()
            }
        }
        
    }
    
    var films = [Film](){
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setupUI()
               
            }
        }
    }
    private let noFilmView = CreatLabelView()
    var completionToRoot : (() -> Void)?
    var completionShow : ((Film) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        collectionView.isHidden = true
    }

    private func setupUI(){
        setupLableView()
        contentView.backgroundColor = UIColor.backgroundColor()
        collectionView.backgroundColor = UIColor.backgroundColor()
        setupCollectionView()
        if films.count > 0 {
            noFilmView.isHidden = true
            collectionView.isHidden = false
        } else {
            noFilmView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LibraryCollectionViewCellCell", bundle: nil), forCellWithReuseIdentifier: LibraryCollectionViewCellCell.identifier)
        collectionView.collectionViewLayout = creatViewLayout()
    }
    func creatViewLayout() -> UICollectionViewCompositionalLayout {
        //item
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
        
        let horizontaltem = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
        let horizontalGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), item: horizontaltem, count: 2)
        
//        let verticalitem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
        let verticalgroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: horizontalGroup, count: 2)
        
        //group
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), items: [item, verticalgroup])
        //section
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    func setupLableView(){
        addSubview(noFilmView)
//        let label = type.title != nil ? type.title : ""
        guard let type = self.type else {return}
        let label = type.title
        
        noFilmView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
        let text = "No_Label".localized() + " " + label.localized()
        let title = "Create".localized() + " " + label.localized()
        noFilmView.configure(with: ActionLabelViewModel(text: text, actionTitle: title))
        noFilmView.didTapCreatLibrary = { [self] in
//            self.createWatchList()
            completionToRoot!()
        
        }
    }
    
    private func showFilmPopupDetail(film: Film){
//        let vc = FilmDetailPopUpViewController()
//        vc.completion = {
//            if let tabItems = self.tabBarController?.tabBar.items {
//                // In this case we want to modify the badge number of the third tab:
//                let tabItem = tabItems[2]
//                tabItem.badgeValue = "New"
//            }
//        }
//        vc.film = film
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true, completion: nil)
        completionShow!(film)
    }
}
extension LibraryCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCellCell.identifier, for: indexPath) as! LibraryCollectionViewCellCell
        cell.film = films[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showFilmPopupDetail(film: films[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
