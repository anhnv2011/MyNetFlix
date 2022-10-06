//
//  SeeAllViewController.swift
//  NetFlix
//
//  Created by MAC on 10/1/22.
//

import UIKit

class SeeAllViewController: UIViewController {
    var cellAimationFlag = [Int]()
    
    @IBOutlet weak var seeAllCollectionView: UICollectionView!
    var films = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
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
        
//        let verticalitem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if cellAimationFlag.contains(indexPath.row) == false {
//            // initia state
//            cell.alpha = 0
//            if indexPath.row % 2 == 0 {
//                let transform = CATransform3DTranslate(CATransform3DIdentity, -500, 20, 0)
//                cell.layer.transform = transform
//
//            } else {
//                let transform = CATransform3DTranslate(CATransform3DIdentity, 500, -200, 0)
//                cell.layer.transform = transform
//
//            }
//            let value = Double(indexPath.row) / 10
//            let delay = min(1, value)
//            print(delay)
//            UIView.animate(withDuration: 1, delay: TimeInterval(delay), options: .curveEaseIn) {
//
//                cell.alpha = 1
//                cell.layer.transform = CATransform3DIdentity
//            } completion: { (_) in
//
//            }
//            cellAimationFlag.append(indexPath.row)
//        }
//
//                // initia state
//                let rotationAngleRadius = 90 * CGFloat(.pi / 180.0)
//                let rotationTransform = CATransform3DMakeRotation(rotationAngleRadius, 0, 0, 1)
//                cell.layer.transform = rotationTransform
//
//                //defind final state after animation
//                UIView.animate(withDuration: 1) {
//                    cell.layer.transform = CATransform3DIdentity
//                }
        
        cell.alpha = 0
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
        }
    }
    
}
