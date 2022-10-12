//
//  DisplayCollectionCell.swift
//  NetFlix
//
//  Created by MAC on 10/12/22.
//

import UIKit
class DisplayCollectionCell {
    static func displayCollectionCell(cell: UICollectionViewCell, indexPath: IndexPath){
        // initia state
        cell.alpha = 0
        if indexPath.row % 2 == 0 {
            let transform = CATransform3DTranslate(CATransform3DIdentity, -500, 200, 0)
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
