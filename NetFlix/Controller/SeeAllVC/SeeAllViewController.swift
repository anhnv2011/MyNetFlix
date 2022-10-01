//
//  SeeAllViewController.swift
//  NetFlix
//
//  Created by MAC on 10/1/22.
//

import UIKit

class SeeAllViewController: UIViewController {

    @IBOutlet weak var seeAllCollectionView: UICollectionView!
    var films = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        print(films)
    }


    func setupCollectionView(){
        seeAllCollectionView.delegate = self
        seeAllCollectionView.dataSource = self
        seeAllCollectionView.register(UINib(nibName: "SeeAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SeeAllCollectionViewCell.identifier)
        seeAllCollectionView.collectionViewLayout = creatViewLayout()
    }

    func creatViewLayout() -> UICollectionViewCompositionalLayout {
        //item
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
        
        let horizontaltem = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
        let horizontalGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), item: horizontaltem, count: 2)
        
        let verticalitem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
        let verticalgroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: horizontalGroup, count: 2)
        
        //group
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), items: [item, verticalgroup])
        //section
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
extension SeeAllViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = seeAllCollectionView.dequeueReusableCell(withReuseIdentifier: SeeAllCollectionViewCell.identifier, for: indexPath) as! SeeAllCollectionViewCell
        cell.film = films[indexPath.row]
        return cell
        
    }
    
    
}
