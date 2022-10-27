//
//  DisplayTableCell.swift
//  Tmdb
//
//  Created by MAC on 10/12/22.
//

import Foundation
import UIKit
class DisplayTableCell {
    
    static func displayTableCell(cell: UITableViewCell, indexPath: IndexPath){
        cell.alpha = 0
        if indexPath.row % 2 == 0 {
            let transform = CATransform3DTranslate(CATransform3DIdentity, -500, 200, 100)
            
            cell.layer.transform = transform
            
        } else {
            let transform = CATransform3DTranslate(CATransform3DIdentity, 500, -200, -100)
            cell.layer.transform = transform
            
        }
//        let value = Double(indexPath.row) / 10
        let delay = 0.07 * Double(indexPath.row)
        print(delay)
        UIView.animate(withDuration: 1,
                       delay: TimeInterval(delay),
                       options: .curveEaseIn) {
           
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        } completion: { (_) in
            
        }
    }
}
